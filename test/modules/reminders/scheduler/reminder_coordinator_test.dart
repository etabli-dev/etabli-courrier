import 'dart:async';

import 'package:courrier/core/db/database.dart';
import 'package:courrier/main.dart';
import 'package:courrier/modules/reminders/scheduler/notification_scheduler.dart';
import 'package:courrier/modules/reminders/scheduler/reminder_coordinator.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Scheduler implements NotificationScheduler {
  final active = <int, ScheduledNotification>{};
  bool permission = true;
  bool fail = false;
  int initializes = 0;
  int prompts = 0;
  Completer<void>? pause;
  Completer<void>? entered;
  @override
  Future<void> initialize() async => initializes++;
  @override
  Future<bool> hasPermission() async => permission;
  @override
  Future<bool> requestPermission() async {
    prompts++;
    return permission;
  }

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    entered?.complete();
    entered = null;
    await pause?.future;
    if (fail) throw StateError('unavailable');
    active[notification.id] = notification;
  }

  @override
  Future<void> cancel(int id) async => active.remove(id);
  @override
  Future<void> cancelAll() async => active.clear();
  @override
  Future<List<int>> scheduledIds() async => active.keys.toList();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CourrierDatabase db;
  late _Scheduler scheduler;
  late ReminderCoordinator coordinator;
  late int collection;
  Future<int> insertTask(String uid) => db
      .into(db.todoItems)
      .insert(
        TodoItemsCompanion.insert(
          collectionId: collection,
          uid: uid,
          summary: Value(uid),
          due: Value(DateTime.now().add(const Duration(hours: 1))),
          rawIcs: '',
        ),
      );
  Future<void> waitFor(bool Function() ready) async {
    for (var attempt = 0; attempt < 40 && !ready(); attempt++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    expect(ready(), isTrue, reason: 'Automatic reminder refresh did not run');
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    final account = await db
        .into(db.accounts)
        .insert(AccountsCompanion.insert(kind: 'local', displayName: 'Local'));
    collection = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'tasks',
            displayName: 'Tasks',
          ),
        );
    scheduler = _Scheduler();
    coordinator = ReminderCoordinator(db: db, scheduler: scheduler);
  });
  tearDown(() async {
    coordinator.dispose();
    await db.close();
  });

  testWidgets(
    'production shell starts reminders and presents startup failures',
    (tester) async {
      await tester.runAsync(() => insertTask('shell'));
      scheduler.fail = true;
      await tester.pumpWidget(
        CourrierApp(database: db, reminders: coordinator),
      );
      await tester.runAsync(() => waitFor(() => coordinator.error != null));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Reminders could not refresh. Open Reminders and choose Reload.',
        ),
        findsOneWidget,
      );
      scheduler.fail = false;
      await tester.runAsync(coordinator.refresh);
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Reminders could not refresh. Open Reminders and choose Reload.',
        ),
        findsNothing,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(milliseconds: 1));
    },
  );

  test('cold start rearms existing work without prompting', () async {
    await insertTask('existing');
    coordinator.start();
    await waitFor(() => scheduler.active.isNotEmpty);
    expect(scheduler.active.values.single.title, 'existing');
    expect(scheduler.prompts, 0);
  });
  test('resume restores missing alarms and reinitializes timezone', () async {
    await insertTask('resume');
    coordinator.start();
    await coordinator.refresh();
    scheduler.active.clear();
    final before = scheduler.initializes;
    coordinator.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await waitFor(() => scheduler.active.isNotEmpty);
    expect(scheduler.initializes, greaterThan(before));
    expect(scheduler.active.values.single.title, 'resume');
  });
  test('committed sync edits and completion refresh the saved plan', () async {
    coordinator.start();
    await coordinator.refresh();
    final task = await insertTask('synced');
    await waitFor(
      () => scheduler.active.values.any((n) => n.title == 'synced'),
    );
    expect(scheduler.active.values.single.title, 'synced');
    await (db.update(db.todoItems)..where((row) => row.id.equals(task))).write(
      const TodoItemsCompanion(summary: Value('renamed')),
    );
    await waitFor(
      () => scheduler.active.values.any((n) => n.title == 'renamed'),
    );
    expect(scheduler.active.values.single.title, 'renamed');
    await (db.update(db.todoItems)..where((row) => row.id.equals(task))).write(
      TodoItemsCompanion(completed: Value(DateTime.now())),
    );
    await waitFor(() => scheduler.active.isEmpty);
    expect(scheduler.active, isEmpty);
  });
  test('denied permission skips scheduling and never prompts', () async {
    await insertTask('denied');
    scheduler.permission = false;
    coordinator.start();
    await coordinator.refresh();
    expect(scheduler.active, isEmpty);
    expect(scheduler.prompts, 0);
    scheduler.permission = true;
    coordinator.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await waitFor(() => scheduler.active.isNotEmpty);
    expect(scheduler.active, hasLength(1));
  });
  test('failed refresh exposes retry and preserves prior alarms', () async {
    await insertTask('prior');
    coordinator.start();
    await coordinator.refresh();
    scheduler.fail = true;
    await coordinator.refresh();
    expect(coordinator.error, contains('Reload'));
    expect(scheduler.active, hasLength(1));
    scheduler.fail = false;
    await coordinator.refresh();
    expect(coordinator.error, isNull);
  });
  test(
    'change during a refresh drains another plan before completing',
    () async {
      await insertTask('first');
      scheduler.pause = Completer<void>();
      final entered = scheduler.entered = Completer<void>();
      final running = coordinator.refresh();
      await entered.future;
      await insertTask('second');
      final queued = coordinator.refresh();
      scheduler.pause!.complete();
      await Future.wait([running, queued]);
      expect(
        scheduler.active.values.map((n) => n.title),
        unorderedEquals(['first', 'second']),
      );
    },
  );
}
