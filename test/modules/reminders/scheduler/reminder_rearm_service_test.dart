import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/reminders/scheduler/notification_scheduler.dart';
import 'package:courrier/modules/reminders/scheduler/reminder_rearm_service.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeScheduler implements NotificationScheduler {
  final Map<int, ScheduledNotification> active = {};
  bool initialized = false;
  bool permissionGranted = true;

  @override
  Future<void> initialize() async => initialized = true;

  @override
  Future<bool> hasPermission() async => permissionGranted;

  @override
  Future<bool> requestPermission() async => permissionGranted = true;

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    active[notification.id] = notification;
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
      'cancelAll runs before scheduling — replaces, never accumulates',
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
