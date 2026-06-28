import 'dart:async';

import '../backend/mail_backend.dart';
import 'incremental_syncer.dart';

// IMAP IDLE driver. Wraps MailBackend.startIdle and triggers an incremental
// sync each time the backend reports a new envelope. Documented background-
// fetch strategy (iOS limits): IDLE only runs in the foreground; we fall
// back to polling via the OS push when the app is in the background. M11
// wires lifecycle observers + the polling timer; this layer ships the
// foreground engine.

class IdleListener {
  IdleListener({required this.backend, required this.syncer});

  final MailBackend backend;
  final IncrementalSyncer syncer;

  bool _active = false;
  bool get isActive => _active;
  final StreamController<IncrementalSyncResult> _events =
      StreamController<IncrementalSyncResult>.broadcast();

  Stream<IncrementalSyncResult> get events => _events.stream;

  Future<void> start(String folderName) async {
    if (_active) {
      return;
    }
    _active = true;
    await backend.startIdle(
      folderName: folderName,
      onEnvelope: (_) async {
        try {
          final result = await syncer.sync(folderName: folderName);
          _events.add(result);
        } on Exception {
          // M11 surfaces errors; the foreground engine just keeps trying.
        }
      },
    );
  }

  Future<void> stop() async {
    if (!_active) {
      return;
    }
    _active = false;
    await backend.stopIdle();
  }

  Future<void> dispose() async {
    await stop();
    await _events.close();
  }
}
