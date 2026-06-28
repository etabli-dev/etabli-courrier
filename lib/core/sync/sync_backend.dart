import 'package:meta/meta.dart';

import '../net/net_error.dart';

// The contract every account-level sync backend implements. M2 fills the DAV
// implementation, M6 the IMAP backend, M8 layers OAuth onto the IMAP one, M9 a
// Nextcloud Notes REST one, M10 a News-API one.
abstract class SyncBackend {
  String get kind;

  // Single full reconciliation pass for one account.
  Future<SyncOutcome> pull({required int accountId});

  // Drain queued local changes for one account. May raise the conflict UI when
  // a PreconditionFailedError comes back.
  Future<SyncOutcome> push({required int accountId});

  // Optional: backends that support push streams (IMAP IDLE) hook themselves
  // into ConnectionManager from here.
  Future<void> startListening({required int accountId}) async {}
  Future<void> stopListening({required int accountId}) async {}
}

@immutable
class SyncOutcome {
  const SyncOutcome({
    required this.success,
    this.pulled = 0,
    this.pushed = 0,
    this.conflicts = 0,
    this.error,
  });

  final bool success;
  final int pulled;
  final int pushed;
  final int conflicts;
  final NetError? error;
}
