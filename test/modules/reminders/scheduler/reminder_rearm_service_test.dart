import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/reminders/scheduler/notification_scheduler.dart';
import 'package:courrier/modules/reminders/scheduler/reminder_rearm_service.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeScheduler implements NotificationScheduler {
  final Map<int, ScheduledNotification> active = {};
  bool initialized = false;
  int? capacity;
  int peakPending = 0;
  bool failSchedule = false;
  bool permissionGranted = true;

  @override
  Future<void> initialize() async => initialized = true;

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<bool> requestPermission() async => permissionGranted = true;

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    if (failSchedule) throw StateError('alarm service unavailable');
    if (capacity != null &&
        !active.containsKey(notification.id) &&
        active.length >= capacity!) {
      throw StateError('notification capacity exceeded');
    }
    active[notification.id] = notification;
    if (active.length > peakPending) peakPending = active.length;
  }

  @override
  Future<void> cancel(int id) async => active.remove(id);

  @override
  Future<void> cancelAll() async => active.clear();

  @override
  Future<List<int>> scheduledIds() async => active.keys.toList();
}

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<({int eventId, int reminderId})> _seedEventWithReminder(
  CourrierDatabase db, {
  required DateTime dtstart,
  required int minutesBefore,
}) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
  final collectionId = await db
      .into(db.collections)
      .insert(
        CollectionsCompanion.insert(
          accountId: accountId,
          kind: 'calendar',
          displayName: 'Calendar',
        ),
      );
  final eventId = await db
      .into(db.calendarEvents)
      .insert(
        CalendarEventsCompanion.insert(
          collectionId: collectionId,
          uid: 'event-uid-1',
          summary: const Value('Standup'),
          dtstart: Value(dtstart),
          rawIcs: 'BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n',
        ),
      );
  final reminderId = await db
      .into(db.eventReminders)
      .insert(
        EventRemindersCompanion.insert(
          eventId: eventId,
          minutesBeforeStart: Value(minutesBefore),
        ),
      );
  return (eventId: eventId, reminderId: reminderId);
}

Future<int> _seedTaskWithDue(
  CourrierDatabase db, {
  required DateTime due,
}) async {
  final accountId = await db
      .into(db.accounts)
      .insert(
        AccountsCompanion.insert(kind: 'local', displayName: 'tasks-acc'),
      );
  final collectionId = await db
      .into(db.collections)
      .insert(
        CollectionsCompanion.insert(
          accountId: accountId,
          kind: 'tasks',
          displayName: 'Today',
        ),
      );
  return db
      .into(db.todoItems)
      .insert(
        TodoItemsCompanion.insert(
          collectionId: collectionId,
          uid: 'task-uid-1',
          summary: const Value('Ship M5'),
          due: Value(due),
          rawIcs: 'BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n',
        ),
      );
}

void main() {
  group('ReminderRearmService', () {
    test(
      '60-slot queue replaces60 obsolete reminders without transient overflow',
      () async {
        final db = _db();
        addTearDown(db.close);
        final now = DateTime.utc(2026, 7, 1, 12);
        final scheduler = FakeScheduler()..capacity = 60;
        for (var i = 0; i < 60; i++) {
          await _seedTaskWithDue(db, due: now.add(Duration(minutes: i + 1)));
          scheduler.active[9000 + i] = ScheduledNotification(
            id: 9000 + i,
            title: 'Old',
            body: '',
            fireAt: now.add(const Duration(days: 2)),
          );
        }
        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => now,
          maximumScheduled: 60,
        );
        expect(await service.rearmAll(), 60);
        expect(scheduler.active, hasLength(60));
        expect(scheduler.active.keys.every((id) => id >= 2000000), isTrue);
        expect(scheduler.peakPending, 60);
      },
    );
    test(
      'limited platforms schedule nearest reminders and retain the full agenda',
      () async {
        final db = _db();
        addTearDown(db.close);
        final now = DateTime.utc(2026, 7, 1, 12);
        await _seedTaskWithDue(db, due: now.add(const Duration(hours: 3)));
        await _seedTaskWithDue(db, due: now.add(const Duration(hours: 1)));
        await _seedTaskWithDue(db, due: now.add(const Duration(hours: 2)));
        final scheduler = FakeScheduler();
        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => now,
          maximumScheduled: 2,
        );
        expect(await service.rearmAll(), 2);
        expect(scheduler.active.values.map((n) => n.fireAt.toUtc()), [
          now.add(const Duration(hours: 1)),
          now.add(const Duration(hours: 2)),
        ]);
        expect(await service.upcoming(), hasLength(3));
      },
    );
    test(
      'refresh at delivery boundary retains due IDs without rescheduling',
      () async {
        final db = _db();
        addTearDown(db.close);
        var now = DateTime.utc(2026, 7, 1, 12);
        await _seedTaskWithDue(db, due: now.add(const Duration(seconds: 30)));
        final scheduler = FakeScheduler();
        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => now,
        );
        expect(await service.rearmAll(), 1);
        final due = Map.of(scheduler.active);
        now = now.add(const Duration(seconds: 30));
        scheduler.failSchedule = true;
        expect(await service.rearmAll(), 0);
        expect(scheduler.active, due);
        now = now.add(const Duration(hours: 2));
        expect(await service.rearmAll(), 0);
        expect(
          scheduler.active,
          due,
        ); // Inexact delivery may legitimately be delayed.
        scheduler.active.clear(); // Simulate delivery by the OS.
        expect(await service.rearmAll(), 0);
        expect(scheduler.active, isEmpty); // Delivered history is not replayed.
      },
    );
    test(
      'rearmAll schedules event reminders + task due notifications',
      () async {
        final db = _db();
        addTearDown(db.close);
        final fixed = DateTime.utc(2026, 7, 1, 12);
        await _seedEventWithReminder(
          db,
          dtstart: DateTime.utc(2026, 7, 2, 10),
          minutesBefore: 15,
        );
        await _seedTaskWithDue(db, due: DateTime.utc(2026, 7, 3, 18));

        final scheduler = FakeScheduler();
        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => fixed,
        );

        final armed = await service.rearmAll();
        expect(armed, 2);
        expect(
          scheduler.active.values.map((n) => n.title),
          containsAll(['Standup', 'Ship M5']),
        );
      },
    );

    test(
      'Simulated reboot: rearm against a fresh scheduler matches DB state',
      () async {
        final db = _db();
        addTearDown(db.close);
        final fixed = DateTime.utc(2026, 7, 1, 12);
        await _seedEventWithReminder(
          db,
          dtstart: DateTime.utc(2026, 7, 2, 10),
          minutesBefore: 15,
        );
        await _seedTaskWithDue(db, due: DateTime.utc(2026, 7, 3, 18));

        // Pretend the OS dropped every scheduled notification on reboot.
        final freshScheduler = FakeScheduler();
        final service = ReminderRearmService(
          db: db,
          scheduler: freshScheduler,
          now: () => fixed,
        );

        // Phase 1 — first cold start.
        final armed = await service.rearmAll();
        expect(armed, 2);
        expect(freshScheduler.active, hasLength(2));

        // Phase 2 — simulated reboot wipes the OS state, app cold-starts again.
        freshScheduler.active.clear();
        expect(freshScheduler.active, isEmpty);
        final armedAgain = await service.rearmAll();
        expect(armedAgain, 2);
        expect(freshScheduler.active, hasLength(2));
      },
    );

    test(
      'rearmAll skips reminders in the past and beyond the horizon',
      () async {
        final db = _db();
        addTearDown(db.close);
        final fixed = DateTime.utc(2026, 7, 1, 12);

        // Past.
        await _seedEventWithReminder(
          db,
          dtstart: DateTime.utc(2026, 1, 1, 10),
          minutesBefore: 0,
        );
        // Beyond 30-day horizon.
        await _seedTaskWithDue(db, due: DateTime.utc(2027));

        final scheduler = FakeScheduler();
        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => fixed,
        );

        final armed = await service.rearmAll();
        expect(armed, 0);
      },
    );

    test(
      'failed scheduling preserves existing alarms and the database plan is readable',
      () async {
        final db = _db();
        addTearDown(db.close);
        final fixed = DateTime.utc(2026, 7, 1, 12);
        await _seedTaskWithDue(db, due: fixed.add(const Duration(days: 1)));
        final old = ScheduledNotification(
          id: 99,
          title: 'Preserve',
          body: '',
          fireAt: fixed,
        );
        final scheduler = FakeScheduler()..active[99] = old;
        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => fixed,
        );
        expect((await service.upcoming()).single.title, 'Ship M5');
        expect(scheduler.active, {99: old});
        scheduler.failSchedule = true;
        await expectLater(service.rearmAll(), throwsStateError);
        expect(scheduler.active, {99: old});
        scheduler.failSchedule = false;
        expect(await service.rearmAll(), 1);
        expect(scheduler.active.containsKey(99), isFalse);
      },
    );

    test(
      'successful reload replaces stale alarms without accumulating duplicates',
      () async {
        final db = _db();
        addTearDown(db.close);
        final fixed = DateTime.utc(2026, 7, 1, 12);
        await _seedTaskWithDue(db, due: DateTime.utc(2026, 7, 3, 18));

        final scheduler = FakeScheduler()
          ..active[999999] = ScheduledNotification(
            id: 999999,
            title: 'stale',
            body: '',
            fireAt: _stale,
          );

        final service = ReminderRearmService(
          db: db,
          scheduler: scheduler,
          now: () => fixed,
        );
        await service.rearmAll();
        expect(scheduler.active.containsKey(999999), isFalse);
        expect(scheduler.active, hasLength(1));
      },
    );
  });
}

final DateTime _stale = DateTime.utc(2020);
