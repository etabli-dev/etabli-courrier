import 'package:courrier/modules/mail/backend/mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/sync/idle_listener.dart';
import 'package:courrier/modules/mail/sync/incremental_syncer.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBackend implements MailBackend {
  void Function(int uid)? _onEnvelope;
  bool isIdling = false;

  @override
  Future<void> connect(MailCredentials credentials) async {}
  @override
  Future<void> disconnect() async {}
  @override
  Future<List<MailFolderHandle>> listFolders() async => const [];
  @override
  Future<List<MailEnvelope>> fetchEnvelopes({
    required String folderName,
    int windowSize = 100,
  }) async => const [];
  @override
  Future<MailBodyPayload> fetchBody({
    required String folderName,
    required int uid,
  }) async => const MailBodyPayload();
  @override
  Future<void> applyFlags({
    required String folderName,
    required List<FlagUpdate> updates,
  }) async {}
  @override
  Future<void> moveMessages({
    required String sourceFolder,
    required String destinationFolder,
    required List<int> uids,
  }) async {}
  @override
  Future<void> expungeTrash({required String trashFolderName}) async {}
  @override
  Future<int> appendMessage({
    required String folderName,
    required String rawMimeBytes,
  }) async => 0;
  @override
  Future<void> sendMessage({
    required String rawMimeBytes,
    required String fromAddress,
    required List<String> recipients,
  }) async {}

  @override
  Future<void> startIdle({
    required String folderName,
    required void Function(int uid) onEnvelope,
  }) async {
    isIdling = true;
    _onEnvelope = onEnvelope;
  }

  @override
  Future<void> stopIdle() async {
    isIdling = false;
    _onEnvelope = null;
  }

  void emit(int uid) => _onEnvelope?.call(uid);
}

class _FakeSyncer implements IncrementalSyncer {
  int syncCalls = 0;

  @override
  Future<IncrementalSyncResult> sync({
    required String folderName,
    int windowSize = 100,
  }) async {
    syncCalls += 1;
    return const IncrementalSyncResult(
      newEnvelopes: [],
      droppedUids: [],
      flagUpdates: [],
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('IdleListener triggers a sync per emitted envelope', (
    tester,
  ) async {
    final backend = _FakeBackend();
    final syncer = _FakeSyncer();
    final listener = IdleListener(backend: backend, syncer: syncer);
    addTearDown(listener.dispose);

    await listener.start('INBOX');
    expect(backend.isIdling, isTrue);

    backend.emit(1);
    backend.emit(2);
    await tester.pump(Duration.zero);

    expect(syncer.syncCalls, 2);

    await listener.stop();
    expect(backend.isIdling, isFalse);
  });
}
