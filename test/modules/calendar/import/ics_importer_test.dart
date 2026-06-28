import 'dart:io';

import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/calendar/import/ics_importer.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('IcsImporter', () {
    test(
      'imports VEVENTs from fixture, preserves unknown vendor properties',
      () async {
        final db = _db();
        addTearDown(db.close);
        final accountId = await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(kind: 'local', displayName: 'Bundled'),
            );
        final collectionId = await db
            .into(db.collections)
            .insert(
              CollectionsCompanion.insert(
                accountId: accountId,
                kind: 'calendar',
                displayName: 'Holidays',
              ),
            );

        final importer = IcsImporter(db: db);
        final contents = File(
          'test/fixtures/ical/vevent_full.ics',
        ).readAsStringSync();

        final upserted = await importer.importVcalendar(
          collectionId: collectionId,
          contents: contents,
        );
        expect(upserted, 1);

        final stored = await (db.select(
          db.calendarEvents,
        )..where((t) => t.collectionId.equals(collectionId))).getSingle();
        expect(stored.uid, 'fb0c0c0e-1234-4abc-9def-aaa111bbb222');
        expect(stored.rawIcs.contains('X-CUSTOM-VENDOR-FIELD:'), isTrue);
        expect(stored.rawIcs.contains('X-WR-CALNAME:'), isTrue);
        expect(stored.rawIcs.contains('BEGIN:VALARM'), isTrue);
        expect(stored.allDay, isFalse);
      },
    );

    test('re-import is idempotent (UID-keyed upsert; no duplicates)', () async {
      final db = _db();
      addTearDown(db.close);
      final accountId = await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(kind: 'local', displayName: 'Bundled'),
          );
      final collectionId = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: accountId,
              kind: 'calendar',
              displayName: 'Holidays',
            ),
          );

      final importer = IcsImporter(db: db);
      final contents = File(
        'test/fixtures/ical/vevent_full.ics',
      ).readAsStringSync();

      await importer.importVcalendar(
        collectionId: collectionId,
        contents: contents,
      );
      await importer.importVcalendar(
        collectionId: collectionId,
        contents: contents,
      );

      final rows = await (db.select(
        db.calendarEvents,
      )..where((t) => t.collectionId.equals(collectionId))).get();
      expect(rows, hasLength(1));
    });

    test('throws on non-VCALENDAR root', () async {
      final db = _db();
      addTearDown(db.close);
      final importer = IcsImporter(db: db);
      expect(
        () => importer.importVcalendar(
          collectionId: 1,
          contents: 'BEGIN:VTODO\r\nUID:x\r\nEND:VTODO\r\n',
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
