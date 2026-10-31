import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/ical/ical_reader.dart';
import '../../../core/ical/vevent.dart';
import '../../../core/net/bounded_http.dart';
import '../../../core/net/dav/dav_client.dart';
import '../../../core/net/net_error.dart';
import '../../../core/sync/change_queue.dart';
import '../../../core/sync/dav_record_pull.dart';
import '../../../core/sync/sync_backend.dart';

// Calendar-specific sync backend. Implements the M1 SyncBackend interface:
// pull() runs sync-collection per calendar collection, updates etags + raw ICS;
// push() drains pending_changes with If-Match etag guard. 412 is surfaced as a
// SyncConflicts row + bumped outcome counter (the UI dialog at M11 resolves).

class CalendarSyncBackend extends SyncBackend {
  CalendarSyncBackend({
    required this.db,
    required this.davClient,
    required this.collectionUrlResolver,
  });

  final CourrierDatabase db;
  final DavClient davClient;

  /// Maps a Collections row into the absolute DAV URL. The orchestrator owns
  /// account base URLs; we ask it to resolve per-collection because we don't
  /// want to embed Nextcloud-shaped path assumptions in this layer.
  final Uri Function(Collection collection) collectionUrlResolver;

  static const IcalReader _reader = IcalReader();

  @override
  String get kind => 'nextcloud';

  @override
  Future<SyncOutcome> pull({required int accountId}) => DavRecordPull(
    db: db,
    client: davClient,
    resolve: collectionUrlResolver,
  ).pull(accountId, 'calendar');

  @override
  Future<SyncOutcome> push({required int accountId}) async {
    var pushed = 0;
    var conflicts = 0;
    NetError? lastError;
    final pending =
        await (db.select(db.pendingChanges)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.entityTable.equals('calendar_events'),
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
    final event = await (db.select(
      db.calendarEvents,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (event == null) {
      return;
    }
    final collection = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(event.collectionId))).getSingle();
    final eventUrl = sameOrigin(
      collectionUrlResolver(collection),
      event.remoteHref ?? '${Uri.encodeComponent(event.uid)}.ics',
    );

    if (collection.accountId != change.accountId) {
      throw const ParseFailureError('account mismatch');
    }
    final creating =
        event.remoteHref == null &&
        change.baseEtag == null &&
        change.operation == 'create';
    if (!creating &&
        change.baseEtag == null &&
        (event.remoteHref != null || change.attempts > 0)) {
      throw const ParseFailureError(
        'remote version is unknown; preserve the local copy and reload before writing',
      );
    }
    if (change.operation == 'delete') {
      if (event.remoteHref != null || change.baseEtag != null) {
        await davClient.delete(url: eventUrl, ifMatchEtag: change.baseEtag);
      }
      await (db.delete(
        db.calendarEvents,
      )..where((t) => t.id.equals(event.id))).go();
      return;
    }

    final payload = change.payload ?? event.rawIcs;
    if (creating) await markDispatched(db, change);
    final result = await davClient.put(
      url: eventUrl,
      body: payload,
      contentType: 'text/calendar; charset=utf-8',
      ifMatchEtag: creating ? null : change.baseEtag,
      ifNoneMatchAny: creating,
    );

    await (db.update(
      db.calendarEvents,
    )..where((t) => t.id.equals(event.id))).write(
      CalendarEventsCompanion(
        etag: Value(result.etag),
        remoteHref: Value(eventUrl.toString()),
      ),
    );
    await acknowledgeEtag(db, change, result.etag);
  }

  Future<void> _recordConflict(
    PendingChange change,
    PreconditionFailedError error,
  ) async {
    final event = await (db.select(
      db.calendarEvents,
    )..where((t) => t.id.equals(change.entityId))).getSingleOrNull();
    if (event == null) {
      return;
    }
    await db
        .into(db.syncConflicts)
        .insert(
          SyncConflictsCompanion.insert(
            accountId: change.accountId,
            entityTable: change.entityTable,
            entityId: change.entityId,
            localPayload: change.payload ?? event.rawIcs,
            serverPayload: '<server payload fetched lazily by resolver UI>',
            serverEtag: Value(error.observedEtag),
          ),
        );
  }

  // Helpful diagnostic for the UI — count of pending changes per collection.
  Future<int> pendingChangeCountFor(int accountId) async {
    final rows =
        await (db.select(db.pendingChanges)..where(
              (t) =>
                  t.accountId.equals(accountId) &
                  t.entityTable.equals('calendar_events'),
            ))
            .get();
    return rows.length;
  }

  static String? readSummaryFromIcs(String ics) {
    try {
      final tree = _reader.parse(ics);
      final vevent = tree.firstChild('VEVENT');
      if (vevent == null) {
        return null;
      }
      return VEvent.from(vevent).summary;
    } on FormatException {
      return null;
    }
  }
}
