import 'package:courrier/core/db/database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _inMemory() =>
    CourrierDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('CourrierDatabase schema v1', () {
    test('creates all tables and accepts a local-only account', () async {
      final db = _inMemory();
      addTearDown(db.close);

      final accountId = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));

      final account = await (db.select(
        db.accounts,
      )..where((t) => t.id.equals(accountId))).getSingle();
      expect(account.kind, 'local');
      expect(account.enabled, isTrue);
      expect(account.baseUrl, isNull);
    });

    test(
      'event carries N reminders + recurrence overrides; cascade deletes',
      () async {
        final db = _inMemory();
        addTearDown(db.close);

        final accountId = await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(kind: 'local', displayName: 'demo'),
            );
        final collectionId = await db
            .into(db.collections)
            .insert(
              CollectionsCompanion.insert(
                accountId: accountId,
                kind: 'calendar',
                displayName: 'Home',
              ),
            );
        final eventId = await db
            .into(db.calendarEvents)
            .insert(
              CalendarEventsCompanion.insert(
                collectionId: collectionId,
                uid: 'evt-uid-1',
                rawIcs: 'BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n',
              ),
            );

        // Three reminders, mixing offsets and absolute trigger.
        await db
            .into(db.eventReminders)
            .insert(
              EventRemindersCompanion.insert(
                eventId: eventId,
                minutesBeforeStart: const Value(15),
              ),
            );
        await db
            .into(db.eventReminders)
            .insert(
              EventRemindersCompanion.insert(
                eventId: eventId,
                minutesBeforeStart: const Value(60),
              ),
            );
        await db
            .into(db.eventReminders)
            .insert(
              EventRemindersCompanion.insert(
                eventId: eventId,
                absoluteTrigger: Value(DateTime.utc(2030)),
                action: const Value('AUDIO'),
              ),
            );

        // EXDATE override survives.
        await db
            .into(db.eventRecurrenceOverrides)
            .insert(
              EventRecurrenceOverridesCompanion.insert(
                eventId: eventId,
                kind: 'EXDATE',
                value: '20300202T120000Z',
              ),
            );

        final remindersBefore = await db.select(db.eventReminders).get();
        expect(remindersBefore, hasLength(3));

        // Cascading delete on the event cleans both child tables.
        await (db.delete(
          db.calendarEvents,
        )..where((t) => t.id.equals(eventId))).go();

        final remindersAfter = await db.select(db.eventReminders).get();
        final overridesAfter = await db
            .select(db.eventRecurrenceOverrides)
            .get();
        expect(remindersAfter, isEmpty);
        expect(overridesAfter, isEmpty);
      },
    );

    test('UID is unique per collection (server identity)', () async {
      final db = _inMemory();
      addTearDown(db.close);

      final accountId = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
      final colA = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: accountId,
              kind: 'calendar',
              displayName: 'A',
            ),
          );
      final colB = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: accountId,
              kind: 'calendar',
              displayName: 'B',
            ),
          );

      // Same UID across two different collections is fine.
      await db
          .into(db.calendarEvents)
          .insert(
            CalendarEventsCompanion.insert(
              collectionId: colA,
              uid: 'shared-uid',
              rawIcs: '',
            ),
          );
      await db
          .into(db.calendarEvents)
          .insert(
            CalendarEventsCompanion.insert(
              collectionId: colB,
              uid: 'shared-uid',
              rawIcs: '',
            ),
          );

      // Same UID twice in the SAME collection must fail.
      expect(
        () => db
            .into(db.calendarEvents)
            .insert(
              CalendarEventsCompanion.insert(
                collectionId: colA,
                uid: 'shared-uid',
                rawIcs: '',
              ),
            ),
        throwsA(anything),
      );
    });

    test('pending change and conflict tables persist payload + etag', () async {
      final db = _inMemory();
      addTearDown(db.close);

      final accountId = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));

      await db
          .into(db.pendingChanges)
          .insert(
            PendingChangesCompanion.insert(
              accountId: accountId,
              entityTable: 'calendar_events',
              entityId: 42,
              operation: 'update',
              baseEtag: const Value('"abc123"'),
              payload: const Value('BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n'),
            ),
          );
      await db
          .into(db.syncConflicts)
          .insert(
            SyncConflictsCompanion.insert(
              accountId: accountId,
              entityTable: 'calendar_events',
              entityId: 42,
              localPayload: 'local',
              serverPayload: 'server',
              serverEtag: const Value('"server-etag"'),
            ),
          );

      final pending = await db.select(db.pendingChanges).getSingle();
      final conflict = await db.select(db.syncConflicts).getSingle();
      expect(pending.baseEtag, '"abc123"');
      expect(pending.attempts, 0);
      expect(conflict.serverEtag, '"server-etag"');
      expect(conflict.resolvedAt, isNull);
    });
  });
}
