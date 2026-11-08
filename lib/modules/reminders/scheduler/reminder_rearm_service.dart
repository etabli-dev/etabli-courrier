import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import 'notification_scheduler.dart';

// Rebuild every scheduled notification from the database. Called:
//   * on cold start of the app (iOS GC + first run after upgrade),
//   * on foreground resume and committed calendar/task/reminder changes,
//   * on demand from Reminders → "Reload".
// Android boot restoration is handled separately by the plugin native receiver.
//
// Build the complete plan before changing OS state. Schedule replacements
// before cancelling stale IDs when capacity permits. On capped platforms, evict
// only obsolete IDs as needed to make room for their replacements.

class ReminderRearmService {
  ReminderRearmService({
    required this.db,
    required this.scheduler,
    DateTime Function()? now,
    this.maximumScheduled,
  }) : _now = now ?? DateTime.now;

  final CourrierDatabase db;
  final NotificationScheduler scheduler;
  final int? maximumScheduled;
  final DateTime Function() _now;

  Future<int>? _inFlight;

  /// Returns the number of notifications armed; concurrent reloads share work.
  Future<int> rearmAll({Duration horizon = const Duration(days: 30)}) {
    return _inFlight ??= _rearm(horizon).whenComplete(() => _inFlight = null);
  }

  Future<int> _rearm(Duration horizon) async {
    final now = _now();
    // Preserve valid due IDs until OS delivery, including delayed inexact alarms.
    // Never schedule past notifications again during a resume/sync refresh.
    final existing = await scheduler.scheduledIds();
    final candidates = await _upcoming(
      horizon: horizon,
      retainPendingIds: existing.toSet(),
    );
    final retained = maximumScheduled == null
        ? candidates
        : candidates.take(maximumScheduled!).toList();
    final desired = retained.where((n) => n.fireAt.isAfter(now)).toList();
    final desiredIds = retained.map((n) => n.id).toSet();
    final pending = existing.toSet();
    final obsolete = existing.where((id) => !desiredIds.contains(id)).toList();
    for (final notification in desired) {
      if (maximumScheduled != null && !pending.contains(notification.id)) {
        while (pending.length >= maximumScheduled!) {
          // Free only obsolete slots. Retained and already-due IDs stay armed.
          final stale = obsolete.firstWhere(pending.contains);
          await scheduler.cancel(stale);
          pending.remove(stale);
        }
      }
      await scheduler.schedule(notification);
      pending.add(notification.id);
    }
    for (final id in obsolete) {
      if (pending.contains(id)) await scheduler.cancel(id);
    }
    return desired.length;
  }

  Future<List<ScheduledNotification>> upcoming({
    Duration horizon = const Duration(days: 30),
  }) => _upcoming(horizon: horizon);

  Future<List<ScheduledNotification>> _upcoming({
    required Duration horizon,
    Set<int> retainPendingIds = const {},
  }) => db.transaction(() async {
    if (horizon.isNegative) throw ArgumentError.value(horizon, 'horizon');
    final now = _now();
    final cutoff = now.add(horizon);
    final result = [
      ...await _eventReminders(
        now: now,
        cutoff: cutoff,
        retainPendingIds: retainPendingIds,
      ),
      ...await _taskDueDates(
        now: now,
        cutoff: cutoff,
        retainPendingIds: retainPendingIds,
      ),
    ];
    result.sort((a, b) => a.fireAt.compareTo(b.fireAt));
    return result;
  });

  Future<List<ScheduledNotification>> _eventReminders({
    required DateTime now,
    required DateTime cutoff,
    required Set<int> retainPendingIds,
  }) async {
    final reminders = await db.select(db.eventReminders).get();
    if (reminders.isEmpty) {
      return [];
    }
    final eventIds = reminders.map((r) => r.eventId).toSet().toList();
    final events =
        await (db.select(db.calendarEvents)..where(
              (t) => t.id.isIn(eventIds) & t.deletedLocally.equals(false),
            ))
            .get();
    final eventsById = {for (final e in events) e.id: e};

    final result = <ScheduledNotification>[];
    for (final reminder in reminders) {
      final event = eventsById[reminder.eventId];
      if (event == null) {
        continue;
      }
      final fireAt = _eventReminderFireTime(reminder: reminder, event: event);
      if (fireAt == null ||
          (fireAt.isBefore(now) &&
              !retainPendingIds.contains(_eventReminderId(reminder.id))) ||
          fireAt.isAfter(cutoff)) {
        continue;
      }
      result.add(
        ScheduledNotification(
          id: _eventReminderId(reminder.id),
          title: event.summary ?? 'Reminder',
          body: _bodyForEvent(event, reminder),
          fireAt: fireAt,
          label: reminder.label,
        ),
      );
    }
    return result;
  }

  Future<List<ScheduledNotification>> _taskDueDates({
    required DateTime now,
    required DateTime cutoff,
    required Set<int> retainPendingIds,
  }) async {
    final tasks =
        await (db.select(db.todoItems)..where(
              (t) =>
                  t.deletedLocally.equals(false) &
                  t.completed.isNull() &
                  t.due.isNotNull() &
                  (t.due.isBetweenValues(now, cutoff) |
                      (t.id.isIn(
                            retainPendingIds
                                .where((id) => id >= 2000000)
                                .map((id) => id - 2000000),
                          ) &
                          t.due.isSmallerOrEqualValue(cutoff))),
            ))
            .get();
    final result = <ScheduledNotification>[];
    for (final task in tasks) {
      final due = task.due;
      if (due == null) {
        continue;
      }
      result.add(
        ScheduledNotification(
          id: _taskDueId(task.id),
          title: task.summary ?? 'Task due',
          body: task.description ?? 'Task is due now.',
          fireAt: due,
        ),
      );
    }
    return result;
  }

  DateTime? _eventReminderFireTime({
    required EventReminder reminder,
    required CalendarEvent event,
  }) {
    if (reminder.absoluteTrigger != null) {
      return reminder.absoluteTrigger;
    }
    if (reminder.minutesBeforeStart != null && event.dtstart != null) {
      return event.dtstart!.subtract(
        Duration(minutes: reminder.minutesBeforeStart!),
      );
    }
    return null;
  }

  String _bodyForEvent(CalendarEvent event, EventReminder reminder) {
    if (reminder.label != null && reminder.label!.isNotEmpty) {
      return reminder.label!;
    }
    if (event.location != null && event.location!.isNotEmpty) {
      return event.location!;
    }
    return 'Reminder';
  }

  // Stable id-space split so event reminders and task dues never collide and
  // can be cancelled individually from either side.
  int _eventReminderId(int reminderId) => 1000000 + reminderId;
  int _taskDueId(int taskId) => 2000000 + taskId;
}
