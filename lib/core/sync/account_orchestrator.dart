import 'dart:async';

import '../db/database.dart';
import 'conflict_resolver.dart';
import 'connection_manager.dart';
import 'sync_backend.dart';

// Wires the pieces together for one app session: which backend handles which
// account, when sync passes are triggered, and where conflicts are routed.
//
// M1 implements registration + per-account pull/push dispatch. Scheduling
// (timed/refresh-on-foreground/idle-driven) lands in M2 and M6 once the real
// backends arrive.
class AccountOrchestrator {
  AccountOrchestrator({
    required this.db,
    required this.connection,
    required this.resolver,
  });

  final CourrierDatabase db;
  final ConnectionManager connection;
  final ConflictResolver resolver;
  final Map<String, SyncBackend> _backendsByKind = <String, SyncBackend>{};

  void registerBackend(SyncBackend backend) {
    _backendsByKind[backend.kind] = backend;
  }

  SyncBackend? backendFor(String kind) => _backendsByKind[kind];

  Future<SyncOutcome> syncOne({required Account account}) async {
    if (connection.state == ConnectionState.offline) {
      return const SyncOutcome(success: false);
    }
    final backend = _backendsByKind[account.kind];
    if (backend == null) {
      return const SyncOutcome(success: false);
    }
    final pull = await backend.pull(accountId: account.id);
    if (!pull.success) {
      return pull;
    }
    final push = await backend.push(accountId: account.id);
    return SyncOutcome(
      success: push.success,
      pulled: pull.pulled,
      pushed: push.pushed,
      conflicts: pull.conflicts + push.conflicts,
      error: push.error ?? pull.error,
    );
  }

  Future<List<SyncOutcome>> syncAll() async {
    final accounts = await (db.select(
      db.accounts,
    )..where((t) => t.enabled.equals(true))).get();
    final outcomes = <SyncOutcome>[];
    for (final account in accounts) {
      outcomes.add(await syncOne(account: account));
    }
    return outcomes;
  }
}
