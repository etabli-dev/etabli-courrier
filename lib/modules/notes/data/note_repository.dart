import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import 'note_draft.dart';

// Offline-first notes repository. Reads/writes hit CourrierDatabase first
// (AUDIT_LOOP dim 6). Sync runs via NotesSyncBackend against Nextcloud
// Notes REST; this class is the canonical local source of truth.
//
// Per-note lock rides core/lock (M11 polish wires the biometric prompt);
// here we just toggle the `locked` column. Locked notes still appear in
// the list (with an icon) but the editor requires an unlock confirmation
// before showing the content.

class NoteRepository {
  NoteRepository({required this.db});

  final CourrierDatabase db;

  // ---- CRUD ---------------------------------------------------------------

  Future<int> createNote(NoteDraft draft) async {
    final id = await db
        .into(db.noteItems)
        .insert(
          NoteItemsCompanion.insert(
            collectionId: draft.collectionId,
            title: draft.title,
            content: draft.content,
            kind: Value(draft.kind.name),
            category: Value(draft.category),
            favorite: Value(draft.favorite),
            locked: Value(draft.locked),
          ),
        );
    await _enqueue(
      accountId: await _accountIdForCollection(draft.collectionId),
      noteId: id,
      operation: 'create',
      payload: draft.content,
    );
    return id;
  }

  Future<void> updateNote(int noteId, NoteDraft draft) async {
    final existing = await (db.select(
      db.noteItems,
    )..where((t) => t.id.equals(noteId))).getSingleOrNull();
    if (existing == null) {
      throw StateError('Note $noteId not found');
    }
    await (db.update(db.noteItems)..where((t) => t.id.equals(noteId))).write(
      NoteItemsCompanion(
        title: Value(draft.title),
        content: Value(draft.content),
        kind: Value(draft.kind.name),
        category: Value(draft.category),
        favorite: Value(draft.favorite),
        locked: Value(draft.locked),
        modified: Value(DateTime.now()),
      ),
    );
    await _enqueue(
      accountId: await _accountIdForCollection(draft.collectionId),
      noteId: noteId,
      operation: 'update',
      payload: draft.content,
      baseEtag: existing.etag,
    );
  }

  Future<void> deleteNote(int noteId) async {
    final existing = await (db.select(
      db.noteItems,
    )..where((t) => t.id.equals(noteId))).getSingleOrNull();
    if (existing == null) {
      return;
    }
    await (db.update(db.noteItems)..where((t) => t.id.equals(noteId))).write(
      const NoteItemsCompanion(deletedLocally: Value(true)),
    );
    await _enqueue(
      accountId: await _accountIdForCollection(existing.collectionId),
      noteId: noteId,
      operation: 'delete',
      baseEtag: existing.etag,
    );
  }

  // ---- Lock --------------------------------------------------------------

  Future<void> setLocked(int noteId, {required bool locked}) async {
    await (db.update(db.noteItems)..where((t) => t.id.equals(noteId))).write(
      NoteItemsCompanion(
        locked: Value(locked),
        modified: Value(DateTime.now()),
      ),
    );
  }

  // ---- Queries -----------------------------------------------------------

  Future<List<NoteItem>> listNotes({int? collectionId}) {
    final q = db.select(db.noteItems)
      ..where((t) => t.deletedLocally.equals(false))
      ..orderBy([
        (t) => OrderingTerm.desc(t.favorite),
        (t) => OrderingTerm.asc(t.title),
      ]);
    if (collectionId != null) {
      q.where((t) => t.collectionId.equals(collectionId));
    }
    return q.get();
  }

  Stream<List<NoteItem>> watchNotes({int? collectionId}) {
    final q = db.select(db.noteItems)
      ..where((t) => t.deletedLocally.equals(false))
      ..orderBy([
        (t) => OrderingTerm.desc(t.favorite),
        (t) => OrderingTerm.asc(t.title),
      ]);
    if (collectionId != null) {
      q.where((t) => t.collectionId.equals(collectionId));
    }
    return q.watch();
  }

  Future<NoteItem?> findById(int noteId) {
    return (db.select(
      db.noteItems,
    )..where((t) => t.id.equals(noteId))).getSingleOrNull();
  }

  // ---- Internals ---------------------------------------------------------

  Future<int> _accountIdForCollection(int collectionId) async {
    final c = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(collectionId))).getSingle();
    return c.accountId;
  }

  Future<void> _enqueue({
    required int accountId,
    required int noteId,
    required String operation,
    String? payload,
    String? baseEtag,
  }) async {
    await db
        .into(db.pendingChanges)
        .insert(
          PendingChangesCompanion.insert(
            accountId: accountId,
            entityTable: 'note_items',
            entityId: noteId,
            operation: operation,
            baseEtag: Value(baseEtag),
            payload: Value(payload),
          ),
        );
  }
}
