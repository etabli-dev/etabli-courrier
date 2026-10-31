import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/net/bounded_http.dart';
import '../../../core/net/dav/dav_client.dart';
import '../../../core/net/net_error.dart';
import '../../../core/sync/change_queue.dart';
import '../../../core/sync/dav_record_pull.dart';
import '../../../core/sync/sync_backend.dart';

// CardDAV-backed sync. Mirrors CalendarSyncBackend but operates on
// kind='contacts' collections and posts vCard payloads.

class ContactsSyncBackend extends SyncBackend {
  ContactsSyncBackend({
    required this.db,
    required this.davClient,
    required this.collectionUrlResolver,
  });

  final CourrierDatabase db;
  final DavClient davClient;
  final Uri Function(Collection collection) collectionUrlResolver;

  @override
  String get kind => 'nextcloud-contacts';

  @override
  Future<SyncOutcome> pull({required int accountId}) => DavRecordPull(
    db: db,
    client: davClient,
    resolve: collectionUrlResolver,
  ).pull(accountId, 'contacts');

  @override
  Future<SyncOutcome> push({required int accountId}) async {
    var pushed = 0;
    var conflicts = 0;
    NetError? lastError;
    final pending =
        await (db.select(db.pendingChanges)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.entityTable.equals('contact_cards'),
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
    final contact = await (db.select(
      db.contactCards,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (contact == null) {
      return;
    }
    final collection = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(contact.collectionId))).getSingle();
    final cardUrl = sameOrigin(
      collectionUrlResolver(collection),
      contact.remoteHref ?? '${Uri.encodeComponent(contact.uid)}.vcf',
    );

    if (collection.accountId != change.accountId) {
      throw const ParseFailureError('account mismatch');
    }
    final creating =
        contact.remoteHref == null &&
        change.baseEtag == null &&
        change.operation == 'create';
    if (!creating &&
        change.baseEtag == null &&
        (contact.remoteHref != null || change.attempts > 0)) {
      throw const ParseFailureError(
        'remote version is unknown; preserve the local copy and reload before writing',
      );
    }
    if (change.operation == 'delete') {
      if (contact.remoteHref != null || change.baseEtag != null) {
        await davClient.delete(url: cardUrl, ifMatchEtag: change.baseEtag);
      }
      await (db.delete(
        db.contactCards,
      )..where((t) => t.id.equals(contact.id))).go();
      return;
    }

    final payload = change.payload ?? contact.rawVcard;
    if (creating) await markDispatched(db, change);
    final result = await davClient.put(
      url: cardUrl,
      body: payload,
      contentType: 'text/vcard; charset=utf-8',
      ifMatchEtag: creating ? null : change.baseEtag,
      ifNoneMatchAny: creating,
    );

    await (db.update(
      db.contactCards,
    )..where((t) => t.id.equals(contact.id))).write(
      ContactCardsCompanion(
        etag: Value(result.etag),
        remoteHref: Value(cardUrl.toString()),
      ),
    );
    await acknowledgeEtag(db, change, result.etag);
  }

  Future<void> _recordConflict(
    PendingChange change,
    PreconditionFailedError error,
  ) async {
    final contact = await (db.select(
      db.contactCards,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (contact == null) {
      return;
    }
    await db
        .into(db.syncConflicts)
        .insert(
          SyncConflictsCompanion.insert(
            accountId: change.accountId,
            entityTable: change.entityTable,
            entityId: change.entityId,
            localPayload: change.payload ?? contact.rawVcard,
            serverPayload: '<server payload fetched lazily by resolver UI>',
            serverEtag: Value(error.observedEtag),
          ),
        );
  }
}
