import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/ical/ical_reader.dart';
import 'package:courrier/core/recurrence/ical_date.dart';
import 'package:courrier/core/sync/change_queue.dart';
import 'package:courrier/core/sync/conflict_recovery.dart';
import 'package:courrier/modules/calendar/import/ics_importer.dart';
import 'package:courrier/modules/notes/data/note_draft.dart';
import 'package:courrier/modules/notes/data/note_repository.dart';
import 'package:courrier/modules/reminders/scheduler/local_notification_scheduler.dart';
import 'package:courrier/modules/tasks/data/task_draft.dart';
import 'package:courrier/modules/tasks/data/task_repository.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  late CourrierDatabase db;
  late int account, collection;
  setUp(() async {
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    account = await db
        .into(db.accounts)
        .insert(
          AccountsCompanion.insert(kind: 'nextcloud', displayName: 'Test'),
        );
    collection = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'notes',
            displayName: 'Notes',
            syncToken: const Value('old-token'),
          ),
        );
  });
  tearDown(() => db.close());
  test(
    'newer offline edit survives an old acknowledgement and rebases its precondition',
    () async {
      final repo = NoteRepository(db: db);
      final draft = NoteDraft(
        collectionId: collection,
        title: 'Title',
        content: 'first',
      );
      final id = await repo.createNote(draft);
      final first = await db.select(db.pendingChanges).getSingle();
      await repo.updateNote(id, draft.copyWith(content: 'second'));
      final second = await db.select(db.pendingChanges).getSingle();
      expect(second.id, greaterThan(first.id));
      expect(second.operation, 'create');
      await acknowledgeEtag(db, first, 'created-etag');
      await (db.delete(
        db.pendingChanges,
      )..where((t) => t.id.equals(first.id))).go();
      final retained = await db.select(db.pendingChanges).getSingle();
      expect(retained.payload, 'second');
      expect(retained.baseEtag, 'created-etag');
      await expectLater(archivePendingEdit(db, first.id), throwsStateError);
      expect((await db.select(db.noteItems).getSingle()).content, 'second');
    },
  );
  test(
    'recovery preserves a locked local record and resets only the source sync token',
    () async {
      final repo = NoteRepository(db: db);
      final id = await repo.createNote(
        NoteDraft(
          collectionId: collection,
          title: 'Private',
          content: 'local draft',
          locked: true,
        ),
      );
      await (db.update(db.noteItems)..where((t) => t.id.equals(id))).write(
        const NoteItemsCompanion(remoteId: Value('12'), etag: Value('etag')),
      );
      final pending = await db.select(db.pendingChanges).getSingle();
      await archivePendingEdit(db, pending.id);
      final saved = await db.select(db.noteItems).getSingle();
      expect(saved.id, id);
      expect(saved.content, 'local draft');
      expect(saved.locked, isTrue);
      expect(saved.remoteId, isNull);
      expect(saved.collectionId, isNot(collection));
      final savedCollection = await (db.select(
        db.collections,
      )..where((t) => t.id.equals(saved.collectionId))).getSingle();
      final owner = await (db.select(
        db.accounts,
      )..where((t) => t.id.equals(savedCollection.accountId))).getSingle();
      expect(owner.kind, 'local');
      expect(await db.select(db.pendingChanges).get(), isEmpty);
      expect(
        (await (db.select(
          db.collections,
        )..where((t) => t.id.equals(collection))).getSingle()).syncToken,
        isNull,
      );
    },
  );
  test(
    'failed task queue insertion rolls back the task; completion queues current ICS',
    () async {
      final taskCollection = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: account,
              kind: 'tasks',
              displayName: 'Tasks',
            ),
          );
      final repo = TaskRepository(db: db, uidGenerator: () => 't-1');
      await db.customStatement(
        "CREATE TRIGGER fail_queue BEFORE INSERT ON pending_changes BEGIN SELECT RAISE(ABORT, 'disk failure'); END",
      );
      final draft = TaskDraft(
        collectionId: taskCollection,
        summary: 'Weekly',
        due: DateTime.utc(2026, 10, 30),
        rrule: 'FREQ=WEEKLY',
        repeatAfterCompletion: true,
      );
      await expectLater(repo.createTask(draft), throwsA(anything));
      expect(await db.select(db.todoItems).get(), isEmpty);
      await db.customStatement('DROP TRIGGER fail_queue');
      final id = await repo.createTask(draft);
      await repo.completeTask(id, at: DateTime.utc(2026, 10, 30, 9));
      final task = await db.select(db.todoItems).getSingle();
      expect(task.completed, isNull);
      expect((await repo.listTasks()).single.id, id);
      expect(
        (await db.select(db.pendingChanges).getSingle()).payload,
        contains('DUE:20261106T090000Z'),
      );
      await expectLater(
        repo.updateTask(
          id,
          TaskDraft(collectionId: collection, summary: 'wrong account'),
        ),
        throwsArgumentError,
      );
      expect((await db.select(db.todoItems).getSingle()).summary, 'Weekly');
    },
  );
  test(
    'ICS import keeps recurrence overrides and timezone and rolls back malformed follow-up',
    () async {
      final cal = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: account,
              kind: 'calendar',
              displayName: 'Calendar',
            ),
          );
      const source =
          'BEGIN:VCALENDAR\nVERSION:2.0\nBEGIN:VTIMEZONE\nTZID:Europe/Berlin\nEND:VTIMEZONE\nBEGIN:VEVENT\nUID:recurring\nDTSTART;TZID=Europe/Berlin:20261030T090000\nRRULE:FREQ=DAILY\nSUMMARY:Original\nEND:VEVENT\nBEGIN:VEVENT\nUID:recurring\nRECURRENCE-ID;TZID=Europe/Berlin:20261031T090000\nDTSTART;TZID=Europe/Berlin:20261031T100000\nSUMMARY:Moved\nEND:VEVENT\nEND:VCALENDAR';
      await IcsImporter(
        db: db,
      ).importVcalendar(collectionId: cal, contents: source);
      final event = await db.select(db.calendarEvents).getSingle();
      expect(event.rawIcs, contains('BEGIN:VTIMEZONE'));
      expect(event.rawIcs, contains('RECURRENCE-ID'));
      final bad = source
          .replaceFirst(
            'END:VCALENDAR',
            'BEGIN:VEVENT\nUID:bad\nDTSTART:20260230T090000Z\nEND:VEVENT\nEND:VCALENDAR',
          )
          .replaceFirst('SUMMARY:Original', 'SUMMARY:Changed');
      await expectLater(
        IcsImporter(db: db).importVcalendar(collectionId: cal, contents: bad),
        throwsFormatException,
      );
      expect(
        (await db.select(db.calendarEvents).getSingle()).rawIcs,
        event.rawIcs,
      );
    },
  );
  test('calendar input rejects invalid dates and excessive component depth', () {
    for (final value in [
      '20260230',
      '20261301',
      '20260101T250000Z',
      '20260101extra',
    ]) {
      expect(() => const IcalDateParser().parse(value), throwsFormatException);
    }
    final nested =
        '${List.filled(70, 'BEGIN:X').join('\n')}\n${List.filled(70, 'END:X').join('\n')}';
    expect(() => const IcalReader().parse(nested), throwsFormatException);
  });
  test('weekly alarm retains 09:00 across both Berlin DST transitions', () {
    tzdata.initializeTimeZones();
    final berlin = tz.getLocation('Europe/Berlin');
    for (final (month, day, expectedHourUtc) in [(3, 28, 7), (10, 24, 8)]) {
      final sample = tz.TZDateTime(berlin, 2026, month, day, 9);
      final next = nextWeeklyOccurrence(sample, DateTime.sunday, sample);
      expect(next.hour, 9);
      expect(next.day, day + 1);
      expect(next.toUtc().hour, expectedHourUtc);
    }
  });
}
