import 'dart:convert';
import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/notes/data/note_contribution.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'reviewed export is repeatable, versioned and never changes original note',
    () async {
      final db = CourrierDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final a = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'Test'));
      final collection = await db
          .into(db.collections)
          .insert(
            CollectionsCompanion.insert(
              accountId: a,
              kind: 'notes',
              displayName: 'Notes',
            ),
          );
      final id = await db
          .into(db.noteItems)
          .insert(
            NoteItemsCompanion.insert(
              collectionId: collection,
              title: 'Review',
              content: 'Long original stays local',
            ),
          );
      final note = await db.select(db.noteItems).getSingle();
      final target = <String, dynamic>{
        'note_id': 'a982d21e-3d77-4f20-9dbc-208a5dd31549',
        'calendar_id': 'notes',
        'event_uid': 'uid',
        'occurrence_start': '2026-11-26T12:00:00Z',
      };
      final one = await exportNoteContribution(
        db,
        note,
        target,
        'Checked short note',
      );
      expect(
        await exportNoteContribution(db, note, target, 'Checked short note'),
        one,
      );
      final two = await exportNoteContribution(
        db,
        note,
        target,
        'Corrected note',
      );
      final decoded = jsonDecode(two.json) as Map<String, dynamic>;
      expect((decoded['source'] as Map<String, dynamic>)['revision'], 2);
      expect(two.json, isNot(contains('Long original')));
      expect((await db.select(db.noteItems).getSingle()).id, id);
      expect(
        (await db.select(db.noteItems).getSingle()).content,
        'Long original stays local',
      );
      expect(
        () => exportNoteContribution(db, note, {
          ...target,
          'event_uid': 'wrong',
        }, 'Corrected note'),
        throwsStateError,
      );
    },
  );
}
