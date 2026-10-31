import 'package:drift/drift.dart';

import '../db/database.dart';

/// Replace the intent identity so an in-flight acknowledgement cannot delete
/// a newer local edit. Preserve the first observed remote precondition.
Future<void> enqueueChange(
  CourrierDatabase db, {
  required int accountId,
  required String table,
  required int entityId,
  required String operation,
  String? payload,
  String? baseEtag,
}) async {
  final pending =
      await (db.select(db.pendingChanges)
            ..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.entityTable.equals(table) &
                  t.entityId.equals(entityId),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final first = pending.firstOrNull;
  final effective = operation == 'delete'
      ? 'delete'
      : first?.operation == 'create'
      ? 'create'
      : operation;
  if (pending.isNotEmpty) {
    await (db.delete(
      db.pendingChanges,
    )..where((t) => t.id.isIn(pending.map((p) => p.id)))).go();
  }
  await db
      .into(db.pendingChanges)
      .insert(
        PendingChangesCompanion.insert(
          accountId: accountId,
          entityTable: table,
          entityId: entityId,
          operation: effective,
          payload: Value(payload),
          baseEtag: Value(first == null ? baseEtag : first.baseEtag),
          attempts: Value(
            pending.fold<int>(
              0,
              (maximum, row) => row.attempts > maximum ? row.attempts : maximum,
            ),
          ),
        ),
      );
}

/// Rebase only later local intents on this client's acknowledged write.
Future<void> acknowledgeEtag(
  CourrierDatabase db,
  PendingChange change,
  String? etag,
) async {
  if (etag == null) return;
  await (db.update(db.pendingChanges)..where(
        (t) =>
            t.accountId.equals(change.accountId) &
            t.entityTable.equals(change.entityTable) &
            t.entityId.equals(change.entityId) &
            t.id.isBiggerThanValue(change.id) &
            (change.baseEtag == null
                ? t.baseEtag.isNull()
                : t.baseEtag.equals(change.baseEtag!)),
      ))
      .write(PendingChangesCompanion(baseEtag: Value(etag)));
  await (db.update(db.pendingChanges)..where(
        (t) =>
            t.accountId.equals(change.accountId) &
            t.entityTable.equals(change.entityTable) &
            t.entityId.equals(change.entityId) &
            t.id.isBiggerThanValue(change.id) &
            t.operation.equals('create') &
            t.baseEtag.equals(etag),
      ))
      .write(const PendingChangesCompanion(operation: Value('update')));
}

/// Persist dispatch before an external create. A crash or lost response leaves
/// evidence that retrying a non-idempotent POST may duplicate remote content.
Future<void> markDispatched(CourrierDatabase db, PendingChange change) async {
  await (db.update(db.pendingChanges)..where(
        (t) =>
            t.accountId.equals(change.accountId) &
            t.entityTable.equals(change.entityTable) &
            t.entityId.equals(change.entityId),
      ))
      .write(const PendingChangesCompanion(attempts: Value(1)));
}
