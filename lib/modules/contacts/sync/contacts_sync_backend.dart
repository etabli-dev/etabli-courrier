import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/net/dav/dav_client.dart';
import '../../../core/net/dav/sync_collection.dart';
import '../../../core/net/net_error.dart';
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
  Future<SyncOutcome> pull({required int accountId}) async {
    var pulled = 0;
    try {
      final collections =
          await (db.select(db.collections)..where(
                (t) =>
                    t.accountId.equals(accountId) &
                    t.kind.equals('contacts') &
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
          await (db.update(db.contactCards)
                ..where((t) => t.collectionId.equals(collection.id)))
              .write(const ContactCardsCompanion(etag: Value(null)));
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
    final cardUrl = collectionUrlResolver(
      collection,
    ).resolve('${contact.uid}.vcf');

    if (change.operation == 'delete') {
      await davClient.delete(url: cardUrl, ifMatchEtag: change.baseEtag);
      await (db.delete(
        db.contactCards,
      )..where((t) => t.id.equals(contact.id))).go();
      return;
    }

    final payload = change.payload ?? contact.rawVcard;
    final result = await davClient.put(
      url: cardUrl,
      body: payload,
      contentType: 'text/vcard; charset=utf-8',
      ifMatchEtag: change.operation == 'update' ? change.baseEtag : null,
      ifNoneMatchAny: change.operation == 'create',
    );

    await (db.update(db.contactCards)..where((t) => t.id.equals(contact.id)))
        .write(ContactCardsCompanion(etag: Value(result.etag)));
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
