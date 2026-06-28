import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/tasks/data/task_draft.dart';
import 'package:courrier/modules/tasks/data/task_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

Future<int> _seedAccountWithCollection(CourrierDatabase db) async {
  final accountId = await db
      .into(db.accounts)
      .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
  return db
      .into(db.collections)
      .insert(
        CollectionsCompanion.insert(
          accountId: accountId,
          kind: 'tasks',
          displayName: 'Today',
        ),
      );
}

void main() {
  group('TaskRepository CRUD', () {
    test('createTask stores ICS + queues pending change', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = TaskRepository(db: db, uidGenerator: () => 'task-uid-1');

      final id = await repo.createTask(
        TaskDraft(
          collectionId: collectionId,
          summary: 'Ship M5',
          priority: 5,
          percentComplete: 40,
          due: DateTime.utc(2026, 7),
        ),
      );

      final task = await (db.select(
        db.todoItems,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(task.uid, 'task-uid-1');
      expect(task.summary, 'Ship M5');
      expect(task.priority, 5);
      expect(task.percentComplete, 40);
      expect(task.rawIcs.contains('UID:task-uid-1'), isTrue);
      expect(task.rawIcs.contains('SUMMARY:Ship M5'), isTrue);
      expect(task.rawIcs.contains('DUE:20260701T000000Z'), isTrue);
      expect(task.rawIcs.contains('PRIORITY:5'), isTrue);

      final pending = await db.select(db.pendingChanges).get();
      expect(pending, hasLength(1));
      expect(pending.first.operation, 'create');
    });

    test('subtask edge: child references parent UID', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      var n = 0;
      final repo = TaskRepository(db: db, uidGenerator: () => 'uid-${++n}');

      await repo.createTask(
        TaskDraft(collectionId: collectionId, summary: 'Parent'),
      );
      final parentUid = (await db.select(db.todoItems).getSingle()).uid;

      final childId = await repo.createTask(
        TaskDraft(
          collectionId: collectionId,
          summary: 'Child',
          parentUid: parentUid,
        ),
      );

      final child = await (db.select(
        db.todoItems,
      )..where((t) => t.id.equals(childId))).getSingle();
      expect(child.parentUid, parentUid);
      expect(
        child.rawIcs.contains('RELATED-TO;RELTYPE=PARENT:$parentUid'),
        isTrue,
      );

      final children = await repo.subtasksOf(parentUid: parentUid);
      expect(children, hasLength(1));
      expect(children.first.summary, 'Child');
    });
  });

  group('Completion', () {
    test(
      'Non-recurring task: complete sets percentComplete=100, completed=now',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = TaskRepository(db: db, uidGenerator: () => 'uid-cnt');

        final id = await repo.createTask(
          TaskDraft(collectionId: collectionId, summary: 'One-shot'),
        );

        final at = DateTime.utc(2026, 7, 4, 12);
        final outcome = await repo.completeTask(id, at: at);
        expect(outcome.advancedTo, isNull);

        final task = await (db.select(
          db.todoItems,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(task.percentComplete, 100);
        expect(task.completed?.toUtc(), at);
      },
    );

    test('Repeat-after-completion advances DUE by RRULE interval', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = TaskRepository(db: db, uidGenerator: () => 'uid-recurring');

      final id = await repo.createTask(
        TaskDraft(
          collectionId: collectionId,
          summary: 'Weekly review',
          due: DateTime.utc(2026, 7, 1, 9),
          rrule: 'FREQ=WEEKLY;INTERVAL=1',
          repeatAfterCompletion: true,
        ),
      );

      // Complete at a moment after the DUE — next should be DUE + 7 days
      // (carrying the original time-of-day).
      final at = DateTime.utc(2026, 7, 1, 9, 5);
      final outcome = await repo.completeTask(id, at: at);
      expect(outcome.advancedTo, isNotNull);

      final task = await (db.select(
        db.todoItems,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(task.percentComplete, 0);
      expect(task.due?.toUtc(), DateTime.utc(2026, 7, 8, 9, 5));
      expect(task.rawIcs.contains('LAST-COMPLETED:20260701T090500Z'), isTrue);
      expect(task.rawIcs.contains('DUE:20260708T090500Z'), isTrue);
      expect(task.rawIcs.contains('PERCENT-COMPLETE:0'), isTrue);
    });

    test(
      'Repeat-after-completion: monthly + interval 2 → DUE + 2 months',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = TaskRepository(
          db: db,
          uidGenerator: () => 'uid-recurring-m',
        );

        final id = await repo.createTask(
          TaskDraft(
            collectionId: collectionId,
            summary: 'Bi-monthly check',
            due: DateTime.utc(2026, 7),
            rrule: 'FREQ=MONTHLY;INTERVAL=2',
            repeatAfterCompletion: true,
          ),
        );

        final outcome = await repo.completeTask(
          id,
          at: DateTime.utc(2026, 7, 1, 12),
        );
        expect(outcome.advancedTo, DateTime.utc(2026, 9, 1, 12));
      },
    );
  });

  group('Listing', () {
    test(
      'listTasks hides tombstones and completed by default; subtasksOf works',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        var n = 0;
        final repo = TaskRepository(db: db, uidGenerator: () => 'uid-${++n}');

        final aliveId = await repo.createTask(
          TaskDraft(
            collectionId: collectionId,
            summary: 'Alive',
            due: DateTime.utc(2026, 7),
          ),
        );
        final completedId = await repo.createTask(
          TaskDraft(
            collectionId: collectionId,
            summary: 'Completed',
            due: DateTime.utc(2026, 7, 2),
          ),
        );
        final tombstonedId = await repo.createTask(
          TaskDraft(
            collectionId: collectionId,
            summary: 'Tombstoned',
            due: DateTime.utc(2026, 7, 3),
          ),
        );
        await repo.completeTask(completedId);
        await repo.deleteTask(tombstonedId);

        final visible = await repo.listTasks();
        expect(visible.map((t) => t.summary), ['Alive']);

        final all = await repo.listTasks(includeCompleted: true);
        expect(all.map((t) => t.summary), ['Alive', 'Completed']);
        expect(aliveId, isNotNull);
      },
    );
  });
}
