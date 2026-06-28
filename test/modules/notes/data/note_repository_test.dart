import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/notes/data/note_draft.dart';
import 'package:courrier/modules/notes/data/note_repository.dart';
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
          kind: 'notes',
          displayName: 'Personal',
        ),
      );
}

void main() {
  group('NoteRepository CRUD', () {
    test('createNote inserts the row + enqueues a pending create', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = NoteRepository(db: db);

      final id = await repo.createNote(
        NoteDraft(
          collectionId: collectionId,
          title: 'Hello',
          content: '- [ ] world',
          kind: NoteKind.checklist,
        ),
      );

      final stored = await repo.findById(id);
      expect(stored, isNotNull);
      expect(stored!.title, 'Hello');
      expect(stored.kind, 'checklist');
      expect(stored.content, '- [ ] world');

      final pending = await db.select(db.pendingChanges).get();
      expect(pending, hasLength(1));
      expect(pending.single.operation, 'create');
    });

    test(
      'updateNote preserves collection + enqueues update with baseEtag',
      () async {
        final db = _db();
        addTearDown(db.close);
        final collectionId = await _seedAccountWithCollection(db);
        final repo = NoteRepository(db: db);

        final id = await repo.createNote(
          NoteDraft(
            collectionId: collectionId,
            title: 'Hello',
            content: 'body',
          ),
        );
        await (db.update(db.noteItems)..where((t) => t.id.equals(id))).write(
          const NoteItemsCompanion(etag: Value('"e1"')),
        );

        await repo.updateNote(
          id,
          NoteDraft(
            collectionId: collectionId,
            title: 'Hello — renamed',
            content: 'updated body',
          ),
        );

        final stored = await repo.findById(id);
        expect(stored!.title, 'Hello — renamed');
        expect(stored.content, 'updated body');

        final pending = await (db.select(
          db.pendingChanges,
        )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
        expect(pending.last.operation, 'update');
        expect(pending.last.baseEtag, '"e1"');
      },
    );

    test('deleteNote tombstones + enqueues delete', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = NoteRepository(db: db);

      final id = await repo.createNote(
        NoteDraft(collectionId: collectionId, title: 'Doomed', content: ''),
      );
      await repo.deleteNote(id);

      final stored = await repo.findById(id);
      expect(stored!.deletedLocally, isTrue);
      final visible = await repo.listNotes();
      expect(visible, isEmpty);
    });
  });

  group('Lock', () {
    test('setLocked flips the locked column', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = NoteRepository(db: db);

      final id = await repo.createNote(
        NoteDraft(collectionId: collectionId, title: 'Secret', content: 'shh'),
      );
      await repo.setLocked(id, locked: true);

      final stored = await repo.findById(id);
      expect(stored!.locked, isTrue);
    });
  });

  group('Listing', () {
    test('listNotes orders favorites first, then alphabetical', () async {
      final db = _db();
      addTearDown(db.close);
      final collectionId = await _seedAccountWithCollection(db);
      final repo = NoteRepository(db: db);

      await repo.createNote(
        NoteDraft(collectionId: collectionId, title: 'Banana', content: ''),
      );
      await repo.createNote(
        NoteDraft(collectionId: collectionId, title: 'Apple', content: ''),
      );
      await repo.createNote(
        NoteDraft(
          collectionId: collectionId,
          title: 'Cherry',
          content: '',
          favorite: true,
        ),
      );

      final notes = await repo.listNotes();
      expect(notes.map((n) => n.title), ['Cherry', 'Apple', 'Banana']);
    });
  });
}
