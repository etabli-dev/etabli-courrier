import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/net/net_error.dart';
import 'package:courrier/core/sync/account_orchestrator.dart';
import 'package:courrier/core/sync/conflict_resolver.dart';
import 'package:courrier/core/sync/connection_manager.dart';
import 'package:courrier/core/sync/sync_backend.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBackend extends SyncBackend {
  _FakeBackend(this.kind, {this.pullPulled = 0, this.pushPushed = 0});

  @override
  final String kind;
  final int pullPulled;
  final int pushPushed;

  int pullCalls = 0;
  int pushCalls = 0;

  @override
  Future<SyncOutcome> pull({required int accountId}) async {
    pullCalls += 1;
    return SyncOutcome(success: true, pulled: pullPulled);
  }

  @override
  Future<SyncOutcome> push({required int accountId}) async {
    pushCalls += 1;
    return SyncOutcome(success: true, pushed: pushPushed);
  }
}

class _FailingPushBackend extends _FakeBackend {
  _FailingPushBackend(super.kind);

  @override
  Future<SyncOutcome> push({required int accountId}) async {
    pushCalls += 1;
    return const SyncOutcome(
      success: false,
      conflicts: 1,
      error: PreconditionFailedError(observedEtag: '"server-etag"'),
    );
  }
}

void main() {
  late CourrierDatabase db;
  setUp(() {
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
  });
  tearDown(() async {
    await db.close();
  });

  group('AccountOrchestrator', () {
    test('dispatches to the backend registered for the account kind', () async {
      final orch = AccountOrchestrator(
        db: db,
        connection: ConnectionManager(),
        resolver: const DeferringConflictResolver(),
      );
      final fake = _FakeBackend('local', pullPulled: 3, pushPushed: 1);
      orch.registerBackend(fake);

      final id = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
      final account = await (db.select(
        db.accounts,
      )..where((t) => t.id.equals(id))).getSingle();

      final outcome = await orch.syncOne(account: account);
      expect(outcome.success, isTrue);
      expect(outcome.pulled, 3);
      expect(outcome.pushed, 1);
      expect(fake.pullCalls, 1);
      expect(fake.pushCalls, 1);
    });

    test('offline connection short-circuits sync', () async {
      final connection = ConnectionManager(initial: ConnectionState.offline);
      final orch = AccountOrchestrator(
        db: db,
        connection: connection,
        resolver: const DeferringConflictResolver(),
      );
      final fake = _FakeBackend('local');
      orch.registerBackend(fake);

      final id = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
      final account = await (db.select(
        db.accounts,
      )..where((t) => t.id.equals(id))).getSingle();

      final outcome = await orch.syncOne(account: account);
      expect(outcome.success, isFalse);
      expect(fake.pullCalls, 0);
      expect(fake.pushCalls, 0);
    });

    test('412 from push surfaces as a conflict in the outcome', () async {
      final orch = AccountOrchestrator(
        db: db,
        connection: ConnectionManager(),
        resolver: const DeferringConflictResolver(),
      );
      final fake = _FailingPushBackend('local');
      orch.registerBackend(fake);

      final id = await db
          .into(db.accounts)
          .insert(AccountsCompanion.insert(kind: 'local', displayName: 'demo'));
      final account = await (db.select(
        db.accounts,
      )..where((t) => t.id.equals(id))).getSingle();

      final outcome = await orch.syncOne(account: account);
      expect(outcome.success, isFalse);
      expect(outcome.conflicts, 1);
      expect(outcome.error, isA<PreconditionFailedError>());
    });
  });

  group('DeferringConflictResolver', () {
    test('always defers — leaves the SyncConflicts row open', () async {
      const resolver = DeferringConflictResolver();
      final res = await resolver.resolve(
        const ConflictContext(
          accountId: 1,
          entityTable: 'calendar_events',
          entityId: 7,
          localPayload: 'L',
          serverPayload: 'S',
        ),
      );
      expect(res, ConflictResolution.defer);
    });
  });
}
