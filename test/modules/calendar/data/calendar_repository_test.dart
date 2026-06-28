import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/calendar/data/calendar_repository.dart';
import 'package:courrier/modules/calendar/data/event_draft.dart';
import 'package:courrier/modules/calendar/data/event_reminder_spec.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
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
          kind: 'calendar',
          displayName: 'Personal',
        ),
      );
}

void main() {
  group('CalendarRepository CRUD', () {
    test(
      'createEvent stores ICS + reminders and enqueues a pending change',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = CalendarRepository(db: db, uidGenerator: () => 'uid-1');

        final id = await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            summary: 'Standup',
            start: DateTime.utc(2026, 6, 20, 10),
            end: DateTime.utc(2026, 6, 20, 10, 30),
            reminders: const [
              EventReminderSpec(minutesBeforeStart: 15),
              EventReminderSpec(minutesBeforeStart: 60),
            ],
            organizer: 'mailto:org@example.org',
            attendees: const [
              'mailto:alice@example.org',
              'mailto:bob@example.org',
            ],
          ),
        );

        final event = await (db.select(
          db.calendarEvents,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(event.summary, 'Standup');
        expect(event.uid, 'uid-1');
        expect(event.rawIcs.contains('UID:uid-1'), isTrue);
        expect(event.rawIcs.contains('SUMMARY:Standup'), isTrue);
        expect(
          event.rawIcs.contains('ATTENDEE:mailto:alice@example.org'),
          isTrue,
        );

        final reminders = await repo.remindersFor(id);
        expect(reminders, hasLength(2));

        final pending = await db.select(db.pendingChanges).get();
        expect(pending, hasLength(1));
        expect(pending.first.operation, 'create');
        expect(pending.first.payload, event.rawIcs);
      },
    );

    test(
      'updateEvent regenerates ICS and queues an update with baseEtag',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = CalendarRepository(db: db, uidGenerator: () => 'uid-1');

        final id = await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            summary: 'Standup',
            start: DateTime.utc(2026, 6, 20, 10),
            end: DateTime.utc(2026, 6, 20, 10, 30),
          ),
        );
        // Pretend a pull populated an etag.
        await (db.update(db.calendarEvents)..where((t) => t.id.equals(id)))
            .write(const CalendarEventsCompanion(etag: Value('"server-1"')));

        await repo.updateEvent(
          id,
          EventDraft(
            collectionId: collectionId,
            summary: 'Standup (renamed)',
            start: DateTime.utc(2026, 6, 20, 10),
            end: DateTime.utc(2026, 6, 20, 10, 45),
          ),
        );

        final stored = await (db.select(
          db.calendarEvents,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(stored.summary, 'Standup (renamed)');

        final pending = await (db.select(
          db.pendingChanges,
        )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
        expect(pending, hasLength(2));
        expect(pending.last.operation, 'update');
        expect(pending.last.baseEtag, '"server-1"');
      },
    );

    test(
      'deleteEvent tombstones locally and enqueues a delete with baseEtag',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = CalendarRepository(db: db);

        final id = await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            summary: 'Doomed',
            start: DateTime.utc(2026, 6, 20, 10),
            end: DateTime.utc(2026, 6, 20, 11),
          ),
        );
        await (db.update(db.calendarEvents)..where((t) => t.id.equals(id)))
            .write(const CalendarEventsCompanion(etag: Value('"server-2"')));

        await repo.deleteEvent(id);

        final stored = await (db.select(
          db.calendarEvents,
        )..where((t) => t.id.equals(id))).getSingle();
        expect(stored.deletedLocally, isTrue);

        final pending = await (db.select(
          db.pendingChanges,
        )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
        expect(pending.last.operation, 'delete');
        expect(pending.last.baseEtag, '"server-2"');
      },
    );
  });

  group('Recurrence delete-occurrence', () {
    test('deleteOccurrence adds an EXDATE row and re-renders ICS', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = CalendarRepository(db: db, uidGenerator: () => 'uid-recur');

      final id = await repo.createEvent(
        EventDraft(
          collectionId: collectionId,
          summary: 'Weekly status',
          start: DateTime.utc(2026, 6, 22, 10),
          end: DateTime.utc(2026, 6, 22, 11),
          rrule: 'FREQ=WEEKLY;BYDAY=MO',
        ),
      );

      await repo.deleteOccurrence(id, DateTime.utc(2026, 7, 6, 10));

      final overrides = await (db.select(
        db.eventRecurrenceOverrides,
      )..where((t) => t.eventId.equals(id))).get();
      expect(overrides, hasLength(1));
      expect(overrides.first.value, '20260706T100000Z');

      final event = await (db.select(
        db.calendarEvents,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(event.rawIcs.contains('EXDATE:20260706T100000Z'), isTrue);
      expect(event.rawIcs.contains('RRULE:FREQ=WEEKLY;BYDAY=MO'), isTrue);
    });

    test('deleteThisAndFollowing appends UNTIL and drops any COUNT', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = CalendarRepository(db: db, uidGenerator: () => 'uid-recur2');

      final id = await repo.createEvent(
        EventDraft(
          collectionId: collectionId,
          summary: 'Sunset series',
          start: DateTime.utc(2026, 6, 22, 10),
          end: DateTime.utc(2026, 6, 22, 11),
          rrule: 'FREQ=WEEKLY;BYDAY=MO;COUNT=20',
        ),
      );

      await repo.deleteThisAndFollowing(id, DateTime.utc(2026, 8, 3, 10));

      final event = await (db.select(
        db.calendarEvents,
      )..where((t) => t.id.equals(id))).getSingle();
      expect(event.rrule, isNotNull);
      expect(event.rrule!.contains('COUNT='), isFalse);
      expect(event.rrule!.contains('UNTIL=20260803T095959Z'), isTrue);
      expect(event.rawIcs.contains('UNTIL=20260803T095959Z'), isTrue);
    });
  });

  group('Range query', () {
    test(
      'eventsBetween returns events in window, sorted, no tombstones',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = CalendarRepository(db: db, uidGenerator: () => 'uid');

        final earlierId = await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            uid: 'a',
            summary: 'Earlier',
            start: DateTime.utc(2026, 6, 10),
            end: DateTime.utc(2026, 6, 10, 1),
          ),
        );
        await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            uid: 'b',
            summary: 'Later',
            start: DateTime.utc(2026, 6, 20),
            end: DateTime.utc(2026, 6, 20, 1),
          ),
        );
        await repo.createEvent(
          EventDraft(
            collectionId: collectionId,
            uid: 'c',
            summary: 'Out of range',
            start: DateTime.utc(2026, 8),
            end: DateTime.utc(2026, 8, 1, 1),
          ),
        );
        await repo.deleteEvent(earlierId);

        final events = await repo.eventsBetween(
          from: DateTime.utc(2026, 6),
          to: DateTime.utc(2026, 6, 30, 23, 59),
        );

        expect(events.map((e) => e.summary), ['Later']);
      },
    );
  });
}
