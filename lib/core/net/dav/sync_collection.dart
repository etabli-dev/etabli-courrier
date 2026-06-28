import 'package:meta/meta.dart';

import '../net_error.dart';
import 'dav_client.dart';
import 'multistatus.dart';
import 'requests.dart';

// sync-collection driver. RFC 6578: server may invalidate any stored token;
// when that happens it responds 403 with a <DAV:valid-sync-token/> condition,
// or 410 Gone. The standard recovery is to re-issue sync-collection with an
// empty token to get a full enumeration plus a fresh token.
//
// `syncCollection` runs the request and, on a recognised token-reset signal,
// transparently retries with an empty token while reporting that a reset
// happened so the caller can wipe its local sync state.

@immutable
class SyncCollectionResult {
  const SyncCollectionResult({
    required this.changedHrefs,
    required this.deletedHrefs,
    required this.newSyncToken,
    required this.tokenWasReset,
  });

  final List<String> changedHrefs;
  final List<String> deletedHrefs;
  final String? newSyncToken;
  final bool tokenWasReset;
}

class SyncCollectionClient {
  SyncCollectionClient(this.client);
  final DavClient client;

  Future<SyncCollectionResult> run({
    required Uri collectionUrl,
    String? syncToken,
  }) async {
    try {
      final report = await client.report(
        url: collectionUrl,
        body: DavRequests.syncCollection(syncToken: syncToken),
      );
      return _parse(report, tokenWasReset: false);
    } on NotFoundError {
      // Stale sync-token — restart from scratch.
      final fresh = await client.report(
        url: collectionUrl,
        body: DavRequests.syncCollection(),
      );
      return _parse(fresh, tokenWasReset: true);
    } on ForbiddenError {
      // Some servers (Nextcloud included) signal token invalidation via 403.
      final fresh = await client.report(
        url: collectionUrl,
        body: DavRequests.syncCollection(),
      );
      return _parse(fresh, tokenWasReset: true);
    }
  }

  SyncCollectionResult _parse(
    DavReportResult report, {
    required bool tokenWasReset,
  }) {
    final changed = <String>[];
    final deleted = <String>[];
    for (final resource in report.multistatus.resources) {
      // A `<status>HTTP/1.1 404 Not Found</status>` at the response level
      // signals a tombstone. We surface it by checking whether the resource
      // had any successful properties — if not, treat as deletion.
      if (resource.properties.isEmpty && resource.resourceTypes.isEmpty) {
        deleted.add(resource.href);
      } else {
        changed.add(resource.href);
      }
    }
    return SyncCollectionResult(
      changedHrefs: changed,
      deletedHrefs: deleted,
      newSyncToken: Multistatus.extractSyncToken(report.rawBody),
      tokenWasReset: tokenWasReset,
    );
  }
}
