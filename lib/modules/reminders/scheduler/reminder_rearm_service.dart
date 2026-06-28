import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import 'notification_scheduler.dart';

// Rebuild every scheduled notification from the database. Called:
//   * on cold start of the app (iOS GC + first run after upgrade),
//   * after the Android BOOT_COMPLETED receiver pushes us back into memory,
//   * on demand from Settings → Reminders → "Reload" (M11).
//
// The rearm is idempotent: cancelAll() wipes whatever the OS is holding, then
// we walk EventReminders + tasks-with-due-date and schedule each one.

class ReminderRearmService {
  ReminderRearmService({
    required this.db,
    required this.scheduler,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final CourrierDatabase db;
  final NotificationScheduler scheduler;
  final DateTime Function() _now;

  /// Returns the number of notifications armed.
  Future<int> rearmAll({Duration horizon = const Duration(days: 30)}) async {
    await scheduler.cancelAll();
    final now = _now();
    final cutoff = now.add(horizon);

    var armed = 0;
    armed += await _rearmEventReminders(now: now, cutoff: cutoff);
    armed += await _rearmTaskDueDates(now: now, cutoff: cutoff);
    return armed;
  }

  Future<int> _rearmEventReminders({
    required DateTime now,
    required DateTime cutoff,
  }) async {
    final reminders = await db.select(db.eventReminders).get();
    if (reminders.isEmpty) {
      return 0;
    }
    final eventIds = reminders.map((r) => r.eventId).toSet().toList();
    final events =
        await (db.select(db.calendarEvents)..where(
              (t) => t.id.isIn(eventIds) & t.deletedLocally.equals(false),
            ))
            .get();
    final eventsById = {for (final e in events) e.id: e};

    var armed = 0;
    for (final reminder in reminders) {
      final event = eventsById[reminder.eventId];
      if (event == null) {
        continue;
      }
      final fireAt = _eventReminderFireTime(reminder: reminder, event: event);
      if (fireAt == null || fireAt.isBefore(now) || fireAt.isAfter(cutoff)) {
        continue;
      }
      await scheduler.schedule(
        ScheduledNotification(
          id: _eventReminderId(reminder.id),
          title: event.summary ?? 'Reminder',
          body: _bodyForEvent(event, reminder),
          fireAt: fireAt,
          label: reminder.label,
        ),
      );
      armed += 1;
    }
    return armed;
  }

  Future<int> _rearmTaskDueDates({
    required DateTime now,
    required DateTime cutoff,
  }) async {
    final tasks =
        await (db.select(db.todoItems)..where(
              (t) =>
                  t.deletedLocally.equals(false) &
                  t.completed.isNull() &
                  t.due.isNotNull() &
                  t.due.isBetweenValues(now, cutoff),
            ))
            .get();
    var armed = 0;
    for (final task in tasks) {
      final due = task.due;
      if (due == null) {
        continue;
      }
      await scheduler.schedule(
        ScheduledNotification(
          id: _taskDueId(task.id),
          title: task.summary ?? 'Task due',
          body: task.description ?? 'Task is due now.',
          fireAt: due,
        ),
      );
      armed += 1;
    }
    return armed;
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
