import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_reader.dart';
import '../../../core/ical/ical_writer.dart';
import 'task_draft.dart';
import 'task_serializer.dart';

// Offline-first VTODO repository.
//
// Two recurrence modes (BUILD_PROMPT M5):
//   * fixed schedule — RRULE on the task; complete() flips to 100% and stops
//   * repeat-after-completion — on complete(), the next due-date is computed
//     from completion time + the interval encoded in RRULE; the row is reset
//     to 0% with the new DUE and a fresh DTSTAMP. The X-* hint flags the
//     mode so reads stay round-tripable.
//
// Subtasks live in the same table via `parentUid` (no separate hierarchy
// table). The wire format is RELATED-TO;RELTYPE=PARENT.

class TaskRepository {
  TaskRepository({
    required this.db,
    TaskSerializer? serializer,
    String Function()? uidGenerator,
  }) : _serializer = serializer ?? const TaskSerializer(),
       _uidGenerator = uidGenerator ?? _defaultUidGenerator;

  final CourrierDatabase db;
  final TaskSerializer _serializer;
  final String Function() _uidGenerator;

  static const IcalReader _reader = IcalReader();
  static const IcalWriter _writer = IcalWriter();

  // ---- CRUD ---------------------------------------------------------------

  Future<int> createTask(TaskDraft draft) async {
    final uid = draft.uid ?? _uidGenerator();
    final ics = _serializer.render(draft, uid: uid);
    final id = await db
        .into(db.todoItems)
        .insert(
          TodoItemsCompanion.insert(
            collectionId: draft.collectionId,
            uid: uid,
            summary: Value(draft.summary),
            description: Value(draft.description),
            due: Value(draft.due),
            priority: Value(draft.priority),
            percentComplete: Value(draft.percentComplete),
            rrule: Value(draft.rrule),
            repeatAfterCompletion: Value(draft.repeatAfterCompletion),
            parentUid: Value(draft.parentUid),
            rawIcs: ics,
          ),
        );
    await _enqueue(
      accountId: await _accountIdForCollection(draft.collectionId),
      taskId: id,
      operation: 'create',
      payload: ics,
    );
    return id;
  }

  Future<void> updateTask(int taskId, TaskDraft draft) async {
    final existing = await (db.select(
      db.todoItems,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (existing == null) {
      throw StateError('Task $taskId not found');
    }
    final uid = existing.uid;
    final patched = _patchExistingIcs(existing.rawIcs, draft, uid: uid);
    await (db.update(db.todoItems)..where((t) => t.id.equals(taskId))).write(
      TodoItemsCompanion(
        summary: Value(draft.summary),
        description: Value(draft.description),
        due: Value(draft.due),
        priority: Value(draft.priority),
        percentComplete: Value(draft.percentComplete),
        rrule: Value(draft.rrule),
        repeatAfterCompletion: Value(draft.repeatAfterCompletion),
        parentUid: Value(draft.parentUid),
        rawIcs: Value(patched),
        lastModified: Value(DateTime.now()),
      ),
    );
    await _enqueue(
      accountId: await _accountIdForCollection(draft.collectionId),
      taskId: taskId,
      operation: 'update',
      payload: patched,
      baseEtag: existing.etag,
    );
  }

  Future<void> deleteTask(int taskId) async {
    final existing = await (db.select(
      db.todoItems,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (existing == null) {
      return;
    }
    await (db.update(db.todoItems)..where((t) => t.id.equals(taskId))).write(
      const TodoItemsCompanion(deletedLocally: Value(true)),
    );
    await _enqueue(
      accountId: await _accountIdForCollection(existing.collectionId),
      taskId: taskId,
      operation: 'delete',
      baseEtag: existing.etag,
    );
  }

  // ---- Completion (with both recurrence modes) ----------------------------

  /// Mark a task complete. Behaviour depends on the recurrence mode:
  ///   * non-recurring → percentComplete=100, completed=now, no further changes
  ///   * fixed RRULE → percentComplete=100, completed=now, RRULE retained for
  ///     pull-side expansion by the calendar UI
  ///   * repeat-after-completion → DUE shifted forward by the interval encoded
  ///     in `RRULE` (FREQ=DAILY/WEEKLY/MONTHLY/YEARLY + INTERVAL), percent
  ///     reset to 0, completion timestamp persisted in the rawIcs
  ///     `LAST-COMPLETED` so the next sync surfaces the chain.
  Future<TaskCompletionOutcome> completeTask(int taskId, {DateTime? at}) async {
    final existing = await (db.select(
      db.todoItems,
    )..where((t) => t.id.equals(taskId))).getSingleOrNull();
    if (existing == null) {
      throw StateError('Task $taskId not found');
    }
    final now = at?.toUtc() ?? DateTime.now().toUtc();

    if (!existing.repeatAfterCompletion) {
      await (db.update(db.todoItems)..where((t) => t.id.equals(taskId))).write(
        TodoItemsCompanion(
          percentComplete: const Value(100),
          completed: Value(now),
          lastModified: Value(DateTime.now()),
        ),
      );
      return const TaskCompletionOutcome();
    }

    final next = _advanceDue(existing.rrule, existing.due, now);
    final patched = _patchCompletionInIcs(existing.rawIcs, next, now);
    await (db.update(db.todoItems)..where((t) => t.id.equals(taskId))).write(
      TodoItemsCompanion(
        percentComplete: const Value(0),
        completed: Value(now),
        due: Value(next),
        rawIcs: Value(patched),
        lastModified: Value(DateTime.now()),
      ),
    );
    return TaskCompletionOutcome(advancedTo: next);
  }

  // ---- Queries ------------------------------------------------------------

  Future<List<TodoItem>> listTasks({
    int? collectionId,
    bool includeCompleted = false,
  }) async {
    final q = db.select(db.todoItems)
      ..where((t) => t.deletedLocally.equals(false))
      ..orderBy([
        (t) => OrderingTerm.asc(t.due),
        (t) => OrderingTerm.desc(t.priority),
        (t) => OrderingTerm.asc(t.summary),
      ]);
    if (collectionId != null) {
      q.where((t) => t.collectionId.equals(collectionId));
    }
    if (!includeCompleted) {
      q.where((t) => t.completed.isNull());
    }
    return q.get();
  }

  Future<List<TodoItem>> subtasksOf({
    required String parentUid,
    int? collectionId,
  }) async {
    final q = db.select(db.todoItems)
      ..where((t) => t.deletedLocally.equals(false))
      ..where((t) => t.parentUid.equals(parentUid))
      ..orderBy([(t) => OrderingTerm.asc(t.summary)]);
    if (collectionId != null) {
      q.where((t) => t.collectionId.equals(collectionId));
    }
    return q.get();
  }

  Future<List<TodoItem>> tasksDueBefore(DateTime cutoff) {
    return (db.select(db.todoItems)
          ..where(
            (t) =>
                t.deletedLocally.equals(false) &
                t.completed.isNull() &
                t.due.isNotNull() &
                t.due.isSmallerThanValue(cutoff),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.due)]))
        .get();
  }

  // ---- Internals ----------------------------------------------------------

  String _patchExistingIcs(
    String existing,
    TaskDraft draft, {
    required String uid,
  }) {
    final tree = _reader.parse(existing);
    final vtodo = tree.firstChild('VTODO');
    if (vtodo == null) {
      // Fall back to a fresh render if the cached ICS got malformed somehow.
      return _serializer.render(draft.copyWith(), uid: uid);
    }
    vtodo
      ..setSingle(IcalProperty(name: 'SUMMARY', value: draft.summary))
      ..setSingle(
        IcalProperty(
          name: 'DTSTAMP',
          value: _formatUtc(DateTime.now().toUtc()),
        ),
      );
    if (draft.description != null) {
      vtodo.setSingle(
        IcalProperty(name: 'DESCRIPTION', value: draft.description!),
      );
    } else {
      vtodo.removeAll('DESCRIPTION');
    }
    if (draft.due != null) {
      vtodo.setSingle(
        IcalProperty(name: 'DUE', value: _formatUtc(draft.due!.toUtc())),
      );
    } else {
      vtodo.removeAll('DUE');
    }
    if (draft.priority != null) {
      vtodo.setSingle(
        IcalProperty(name: 'PRIORITY', value: '${draft.priority}'),
      );
    } else {
      vtodo.removeAll('PRIORITY');
    }
    if (draft.percentComplete != null) {
      vtodo.setSingle(
        IcalProperty(
          name: 'PERCENT-COMPLETE',
          value: '${draft.percentComplete}',
        ),
      );
    } else {
      vtodo.removeAll('PERCENT-COMPLETE');
    }
    if (draft.rrule != null) {
      vtodo.setSingle(IcalProperty(name: 'RRULE', value: draft.rrule!));
    } else {
      vtodo.removeAll('RRULE');
    }
    if (draft.repeatAfterCompletion) {
      vtodo.setSingle(
        IcalProperty(name: 'X-TASKS-ORG-REPEAT-COMPLETED', value: 'true'),
      );
    } else {
      vtodo.removeAll('X-TASKS-ORG-REPEAT-COMPLETED');
    }
    if (draft.parentUid != null) {
      // RELATED-TO is cardinality-N in RFC 5545; the M2 setSingle replaces
      // only the first match. For tasks we treat parent as exactly one.
      vtodo.removeAll('RELATED-TO');
      vtodo.properties.add(
        IcalProperty(
          name: 'RELATED-TO',
          parameters: const {
            'RELTYPE': ['PARENT'],
          },
          value: draft.parentUid!,
        ),
      );
    }
    return _writer.render(tree);
  }

  String _patchCompletionInIcs(
    String existing,
    DateTime? nextDue,
    DateTime completedAt,
  ) {
    final tree = _reader.parse(existing);
    final vtodo = tree.firstChild('VTODO');
    if (vtodo == null) {
      return existing;
    }
    vtodo
      ..setSingle(IcalProperty(name: 'PERCENT-COMPLETE', value: '0'))
      ..setSingle(
        IcalProperty(name: 'LAST-COMPLETED', value: _formatUtc(completedAt)),
      );
    if (nextDue != null) {
      vtodo.setSingle(IcalProperty(name: 'DUE', value: _formatUtc(nextDue)));
    }
    return _writer.render(tree);
  }

  DateTime? _advanceDue(String? rrule, DateTime? currentDue, DateTime now) {
    if (rrule == null) {
      // No RRULE → caller said repeat-after-completion but didn't supply
      // an interval. Default to one day.
      return now.add(const Duration(days: 1));
    }
    final parts = <String, String>{};
    for (final part in rrule.split(';')) {
      final equals = part.indexOf('=');
      if (equals < 0) {
        continue;
      }
      parts[part.substring(0, equals).toUpperCase()] = part.substring(
        equals + 1,
      );
    }
    final freq = parts['FREQ']?.toUpperCase();
    final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;
    final base = currentDue ?? now;
    final reference = base.isBefore(now) ? now : base;
    switch (freq) {
      case 'DAILY':
        return reference.add(Duration(days: interval));
      case 'WEEKLY':
        return reference.add(Duration(days: 7 * interval));
      case 'MONTHLY':
        return DateTime.utc(
          reference.year,
          reference.month + interval,
          reference.day,
          reference.hour,
          reference.minute,
          reference.second,
        );
      case 'YEARLY':
        return DateTime.utc(
          reference.year + interval,
          reference.month,
          reference.day,
          reference.hour,
          reference.minute,
          reference.second,
        );
      default:
        return reference.add(const Duration(days: 1));
    }
  }

  Future<int> _accountIdForCollection(int collectionId) async {
    final c = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(collectionId))).getSingle();
    return c.accountId;
  }

  Future<void> _enqueue({
    required int accountId,
    required int taskId,
    required String operation,
    String? payload,
    String? baseEtag,
  }) async {
    await db
        .into(db.pendingChanges)
        .insert(
          PendingChangesCompanion.insert(
            accountId: accountId,
            entityTable: 'todo_items',
            entityId: taskId,
            operation: operation,
            baseEtag: Value(baseEtag),
            payload: Value(payload),
          ),
        );
  }

  String _formatUtc(DateTime dt) {
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return '$yyyy$mm${dd}T$hh$mi${ss}Z';
  }
}

class TaskCompletionOutcome {
  const TaskCompletionOutcome({this.advancedTo});

  /// `null` when no repeat-after-completion took place. Otherwise the new DUE.
  final DateTime? advancedTo;
}

int _uidCounter = 0;
String _defaultUidGenerator() {
  final now = DateTime.now().toUtc();
  return '${now.millisecondsSinceEpoch}-${now.microsecond}-${++_uidCounter}'
      '@etabli.dev';
}
