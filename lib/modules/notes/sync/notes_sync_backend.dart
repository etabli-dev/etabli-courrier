import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/net/net_error.dart';
import '../../../core/sync/sync_backend.dart';
import 'nextcloud_notes_client.dart';

class NotesSyncBackend extends SyncBackend {
  NotesSyncBackend({required this.db, required this.client});

  final CourrierDatabase db;
  final NextcloudNotesClient client;

  @override
  String get kind => 'nextcloud-notes';

  @override
  Future<SyncOutcome> pull({required int accountId}) async {
    var pulled = 0;
    try {
      final collections =
          await (db.select(db.collections)..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.kind.equals('notes') &
                    t.enabled.equals(true),
              ))
              .get();
      final remoteNotes = await client.listNotes();
      for (final collection in collections) {
        for (final remote in remoteNotes) {
          final remoteId = remote.id.toString();
          final existing =
              await (db.select(db.noteItems)..where(
                    (t) =>
                        t.collectionId.equals(collection.id) &
                        t.remoteId.equals(remoteId),
                  ))
                  .getSingleOrNull();
          if (existing == null) {
            await db
                .into(db.noteItems)
                .insert(
                  NoteItemsCompanion.insert(
                    collectionId: collection.id,
                    remoteId: Value(remoteId),
                    etag: Value(remote.etag),
                    title: remote.title,
                    content: remote.content,
                    category: Value(remote.category),
                    favorite: Value(remote.favorite),
                    modified: Value(remote.modified),
                  ),
                );
            pulled += 1;
          } else {
            await (db.update(
              db.noteItems,
            )..where((t) => t.id.equals(existing.id))).write(
              NoteItemsCompanion(
                etag: Value(remote.etag),
                title: Value(remote.title),
                content: Value(remote.content),
                category: Value(remote.category),
                favorite: Value(remote.favorite),
                modified: Value(remote.modified),
              ),
            );
          }
        }
        await (db.update(db.collections)
              ..where((t) => t.id.equals(collection.id)))
            .write(CollectionsCompanion(lastSyncedAt: Value(DateTime.now())));
      }
      return SyncOutcome(success: true, pulled: pulled);
    } on NetError catch (e) {
      return SyncOutcome(success: false, error: e);
    }
  }

  @override
  Future<SyncOutcome> push({required int accountId}) async {
    var pushed = 0;
    var conflicts = 0;
    NetError? lastError;
    final pending =
        await (db.select(db.pendingChanges)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.entityTable.equals('note_items'),
            ))
            .get();
    for (final change in pending) {
      try {
        await _applyOne(change);
        await (db.delete(
          db.pendingChanges,
        )..where((t) => t.id.equals(change.id))).go();
        pushed += 1;
      } on PreconditionFailedError catch (e) {
        await _recordConflict(change, e);
        conflicts += 1;
        lastError = e;
      } on NetError catch (e) {
        await (db.update(
          db.pendingChanges,
        )..where((t) => t.id.equals(change.id))).write(
          PendingChangesCompanion(
            attempts: Value(change.attempts + 1),
            lastError: Value(e.message),
          ),
        );
        lastError = e;
      }
    }
    return SyncOutcome(
      success: conflicts == 0 && lastError == null,
      pushed: pushed,
      conflicts: conflicts,
      error: lastError,
    );
  }

  Future<void> _applyOne(PendingChange change) async {
    final note = await (db.select(
      db.noteItems,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (note == null) {
      return;
    }

    if (change.operation == 'delete') {
      if (note.remoteId != null) {
        await client.deleteNote(
          id: int.parse(note.remoteId!),
          ifMatchEtag: change.baseEtag,
        );
      }
      await (db.delete(db.noteItems)..where((t) => t.id.equals(note.id))).go();
      return;
    }

    if (change.operation == 'create' || note.remoteId == null) {
      final created = await client.createNote(
        title: note.title,
        content: note.content,
        category: note.category,
        favorite: note.favorite,
      );
      await (db.update(db.noteItems)..where((t) => t.id.equals(note.id))).write(
        NoteItemsCompanion(
          remoteId: Value(created.id.toString()),
          etag: Value(created.etag),
          modified: Value(created.modified),
        ),
      );
      return;
    }

    final updated = await client.updateNote(
      id: int.parse(note.remoteId!),
      title: note.title,
      content: note.content,
      category: note.category,
      favorite: note.favorite,
      ifMatchEtag: change.baseEtag,
    );
    await (db.update(db.noteItems)..where((t) => t.id.equals(note.id))).write(
      NoteItemsCompanion(
        etag: Value(updated.etag),
        modified: Value(updated.modified),
      ),
    );
  }

  Future<void> _recordConflict(
    PendingChange change,
    PreconditionFailedError error,
  ) async {
    final note = await (db.select(
      db.noteItems,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (note == null) {
      return;
    }
    await db
        .into(db.syncConflicts)
        .insert(
          SyncConflictsCompanion.insert(
            accountId: change.accountId,
            entityTable: change.entityTable,
            entityId: change.entityId,
            localPayload: change.payload ?? note.content,
            serverPayload: '<server payload fetched lazily by resolver UI>',
            serverEtag: Value(error.observedEtag),
          ),
        );
  }
}
