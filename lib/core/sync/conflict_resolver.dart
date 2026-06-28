import 'package:meta/meta.dart';

// The conflict UI contract (BUILD_PROMPT M1):
//   * server-wins on pull (silently — no UI)
//   * last-write-wins on push (the local write replaces the server copy)
//   * a surfaced conflict only happens when the server moved between our
//     observed etag and our PUT (HTTP 412). The user picks the resolution via
//     a ConflictResolver.
//
// M1 ships the contract + a "defer" (keep both, user resolves later) default.
// M11 wires the actual dialog UI; the AUDIT_LOOP dim 6 invariant "conflicts
// surface in UI, not just logs" is what the dialog satisfies.

enum ConflictResolution { keepLocal, keepServer, keepBoth, defer }

@immutable
class ConflictContext {
  const ConflictContext({
    required this.accountId,
    required this.entityTable,
    required this.entityId,
    required this.localPayload,
    required this.serverPayload,
    this.serverEtag,
  });

  final int accountId;
  final String entityTable;
  final int entityId;
  final String localPayload;
  final String serverPayload;
  final String? serverEtag;
}

abstract class ConflictResolver {
  Future<ConflictResolution> resolve(ConflictContext context);
}

// Default resolver — used when no UI is attached (tests, headless sync passes
// before M11). Defers every conflict, leaving the SyncConflicts row open so the
// user can resolve later.
class DeferringConflictResolver implements ConflictResolver {
  const DeferringConflictResolver();

  @override
  Future<ConflictResolution> resolve(ConflictContext context) async =>
      ConflictResolution.defer;
}
