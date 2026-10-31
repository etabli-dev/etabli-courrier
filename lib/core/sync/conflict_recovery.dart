import 'package:drift/drift.dart';
import '../db/database.dart';

/// Preserve the current local record in a separate offline collection, then
/// permit a full server reload. A stale queue identity cannot discard a new edit.
Future<void> archivePendingEdit(
  CourrierDatabase db,
  int pendingId,
) => db.transaction(() async {
  final pending = await (db.select(
    db.pendingChanges,
  )..where((t) => t.id.equals(pendingId))).getSingleOrNull();
  if (pending == null) {
    throw StateError(
      'This edit changed. Refresh the list and review it again.',
    );
  }
  final (table, kind) = switch (pending.entityTable) {
    'calendar_events' => ('calendar_events', 'calendar'),
    'contact_cards' => ('contact_cards', 'contacts'),
    'todo_items' => ('todo_items', 'tasks'),
    'note_items' => ('note_items', 'notes'),
    _ => throw StateError('This record type does not support recovery.'),
  };
  final row = await db
      .customSelect(
        'SELECT collection_id FROM $table WHERE id = ?',
        variables: [Variable(pending.entityId)],
      )
      .getSingle();
  final original = await (db.select(
    db.collections,
  )..where((t) => t.id.equals(row.read<int>('collection_id')))).getSingle();
  if (original.accountId != pending.accountId) {
    throw StateError('Account mismatch.');
  }
  final archive =
      await (db.select(db.accounts)..where(
            (t) =>
                t.kind.equals('local') &
                t.displayName.equals('Preserved sync conflicts'),
          ))
          .getSingleOrNull();
  final archiveId =
      archive?.id ??
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              kind: 'local',
              displayName: 'Preserved sync conflicts',
            ),
          );
  final collectionId = await db
      .into(db.collections)
      .insert(
        CollectionsCompanion.insert(
          accountId: archiveId,
          kind: kind,
          displayName: 'Offline copy · ${original.displayName}',
        ),
      );
  final remoteField = table == 'note_items' ? 'remote_id' : 'remote_href';
  await db.customUpdate(
    'UPDATE $table SET collection_id = ?, $remoteField = NULL, etag = NULL, deleted_locally = 0 WHERE id = ?',
    variables: [Variable(collectionId), Variable(pending.entityId)],
    updates: {db.calendarEvents, db.contactCards, db.todoItems, db.noteItems},
  );
  await (db.delete(db.pendingChanges)..where(
        (t) =>
            t.accountId.equals(pending.accountId) &
            t.entityTable.equals(table) &
            t.entityId.equals(pending.entityId),
      ))
      .go();
  await (db.update(db.syncConflicts)..where(
        (t) =>
            t.accountId.equals(pending.accountId) &
            t.entityTable.equals(table) &
            t.entityId.equals(pending.entityId),
      ))
      .write(
        SyncConflictsCompanion(
          resolution: const Value('keepBoth'),
          resolvedAt: Value(DateTime.now()),
        ),
      );
  await (db.update(db.collections)..where((t) => t.id.equals(original.id)))
      .write(const CollectionsCompanion(syncToken: Value(null)));
});
