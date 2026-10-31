import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/net/bounded_http.dart';
import '../../../core/net/dav/dav_client.dart';
import '../../../core/net/net_error.dart';
import '../../../core/sync/change_queue.dart';
import '../../../core/sync/dav_record_pull.dart';
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
  Future<SyncOutcome> pull({required int accountId}) => DavRecordPull(
    db: db,
    client: davClient,
    resolve: collectionUrlResolver,
  ).pull(accountId, 'tasks');

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
    final url = sameOrigin(
      collectionUrlResolver(collection),
      task.remoteHref ?? '${Uri.encodeComponent(task.uid)}.ics',
    );

    if (collection.accountId != change.accountId) {
      throw const ParseFailureError('account mismatch');
    }
    final creating =
        task.remoteHref == null &&
        change.baseEtag == null &&
        change.operation == 'create';
    if (!creating &&
        change.baseEtag == null &&
        (task.remoteHref != null || change.attempts > 0)) {
      throw const ParseFailureError(
        'remote version is unknown; preserve the local copy and reload before writing',
      );
    }
    if (change.operation == 'delete') {
      if (task.remoteHref != null || change.baseEtag != null) {
        await davClient.delete(url: url, ifMatchEtag: change.baseEtag);
      }
      await (db.delete(db.todoItems)..where((t) => t.id.equals(task.id))).go();
      return;
    }
    final payload = change.payload ?? task.rawIcs;
    if (creating) await markDispatched(db, change);
    final result = await davClient.put(
      url: url,
      body: payload,
      contentType: 'text/calendar; charset=utf-8',
      ifMatchEtag: creating ? null : change.baseEtag,
      ifNoneMatchAny: creating,
    );
    await (db.update(db.todoItems)..where((t) => t.id.equals(task.id))).write(
      TodoItemsCompanion(
        etag: Value(result.etag),
        remoteHref: Value(url.toString()),
      ),
    );
    await acknowledgeEtag(db, change, result.etag);
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
