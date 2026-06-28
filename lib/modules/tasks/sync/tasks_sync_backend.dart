import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/net/dav/dav_client.dart';
import '../../../core/net/dav/sync_collection.dart';
import '../../../core/net/net_error.dart';
import '../../../core/sync/sync_backend.dart';

class TasksSyncBackend extends SyncBackend {
  TasksSyncBackend({
    required this.db,
    required this.davClient,
    required this.collectionUrlResolver,
  });

  final CourrierDatabase db;
  final DavClient davClient;
  final Uri Function(Collection collection) collectionUrlResolver;

  @override
  String get kind => 'nextcloud-tasks';

  @override
  Future<SyncOutcome> pull({required int accountId}) async {
    var pulled = 0;
    try {
      final collections =
          await (db.select(db.collections)..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.kind.equals('tasks') &
                    t.enabled.equals(true),
              ))
              .get();
      for (final collection in collections) {
        final result = await SyncCollectionClient(davClient).run(
          collectionUrl: collectionUrlResolver(collection),
          syncToken: collection.syncToken,
        );
        pulled += result.changedHrefs.length;
        if (result.tokenWasReset) {
          await (db.update(db.todoItems)
                ..where((t) => t.collectionId.equals(collection.id)))
              .write(const TodoItemsCompanion(etag: Value(null)));
        }
        await (db.update(
          db.collections,
        )..where((t) => t.id.equals(collection.id))).write(
          CollectionsCompanion(
            syncToken: Value(result.newSyncToken),
            lastSyncedAt: Value(DateTime.now()),
          ),
        );
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
                  t.entityTable.equals('todo_items'),
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
    final task = await (db.select(
      db.todoItems,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (task == null) {
      return;
    }
    final collection = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(task.collectionId))).getSingle();
    final url = collectionUrlResolver(collection).resolve('${task.uid}.ics');

    if (change.operation == 'delete') {
      await davClient.delete(url: url, ifMatchEtag: change.baseEtag);
      await (db.delete(db.todoItems)..where((t) => t.id.equals(task.id))).go();
      return;
    }
    final payload = change.payload ?? task.rawIcs;
    final result = await davClient.put(
      url: url,
      body: payload,
      contentType: 'text/calendar; charset=utf-8',
      ifMatchEtag: change.operation == 'update' ? change.baseEtag : null,
      ifNoneMatchAny: change.operation == 'create',
    );
    await (db.update(db.todoItems)..where((t) => t.id.equals(task.id))).write(
      TodoItemsCompanion(etag: Value(result.etag)),
    );
  }

  Future<void> _recordConflict(
    PendingChange change,
    PreconditionFailedError error,
  ) async {
    final task = await (db.select(
      db.todoItems,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (task == null) {
      return;
    }
    await db
        .into(db.syncConflicts)
        .insert(
          SyncConflictsCompanion.insert(
            accountId: change.accountId,
            entityTable: change.entityTable,
            entityId: change.entityId,
            localPayload: change.payload ?? task.rawIcs,
            serverPayload: '<server payload fetched lazily by resolver UI>',
            serverEtag: Value(error.observedEtag),
          ),
        );
  }
}
