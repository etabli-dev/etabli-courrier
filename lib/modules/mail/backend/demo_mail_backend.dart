import '../../../core/net/net_error.dart';
import 'mail_backend.dart';
import 'mail_credentials.dart';

// In-memory MailBackend used by tests, screenshots (M13), and the bundled
// sample-content path (M14). Seeded with realistic sample mail including:
//   * a 3-message thread on References + In-Reply-To
//   * one HTML-only message containing a remote img tag (proves the render
//     path does NOT fetch external content)
//   * a couple of plain-text messages
//   * one message with an attachment metadata entry
//
// The constructor optionally takes a custom seed map for tests that need a
// specific layout. `seedDefault()` gives the canonical sample set.

class DemoMailBackend implements MailBackend {
  DemoMailBackend() : _folders = _defaultFolders();

  final Map<String, _DemoFolder> _folders;
  int _autoUid = 200;
  MailCredentials? _credentials;

  @override
  Future<void> connect(MailCredentials credentials) async {
    _credentials = credentials;
  }

  @override
  Future<void> disconnect() async {
    _credentials = null;
  }

  @override
  Future<List<MailFolderHandle>> listFolders() async {
    _ensureConnected();
    return _folders.values
        .map((f) => MailFolderHandle(name: f.name, specialUse: f.specialUse))
        .toList(growable: false);
  }

  @override
  Future<List<MailEnvelope>> fetchEnvelopes({
    required String folderName,
    int windowSize = 100,
  }) async {
    _ensureConnected();
    final folder = _folder(folderName);
    final sorted = folder.messages.values.toList()
      ..sort((a, b) => b.envelope.receivedAt.compareTo(a.envelope.receivedAt));
    return sorted
        .take(windowSize)
        .map((m) => m.envelope)
        .toList(growable: false);
  }

  @override
  Future<MailBodyPayload> fetchBody({
    required String folderName,
    required int uid,
  }) async {
    _ensureConnected();
    final folder = _folder(folderName);
    final message = folder.messages[uid];
    if (message == null) {
      throw const NotFoundError();
    }
    return message.body;
  }

  @override
  Future<void> applyFlags({
    required String folderName,
    required List<FlagUpdate> updates,
  }) async {
    _ensureConnected();
    final folder = _folder(folderName);
    for (final update in updates) {
      final entry = folder.messages[update.uid];
      if (entry == null) {
        continue;
      }
      var seen = entry.envelope.flags.seen;
      var flagged = entry.envelope.flags.flagged;
      var answered = entry.envelope.flags.answered;
      switch (update.flag) {
        case 'seen':
          seen = update.value;
        case 'flagged':
          flagged = update.value;
        case 'answered':
          answered = update.value;
      }
      folder.messages[update.uid] = entry.copyWithFlags(
        seen: seen,
        flagged: flagged,
        answered: answered,
      );
    }
  }

  @override
  Future<void> moveMessages({
    required String sourceFolder,
    required String destinationFolder,
    required List<int> uids,
  }) async {
    _ensureConnected();
    final source = _folder(sourceFolder);
    final destination = _folder(destinationFolder);
    for (final uid in uids) {
      final entry = source.messages.remove(uid);
      if (entry == null) {
        continue;
      }
      final newUid = ++_autoUid;
      final newEnvelope = entry.envelope.copyWith(uid: newUid);
      destination.messages[newUid] = _DemoMessage(
        envelope: newEnvelope,
        body: entry.body,
      );
    }
  }

  @override
  Future<void> expungeTrash({required String trashFolderName}) async {
    _ensureConnected();
    _folder(trashFolderName).messages.clear();
  }

  @override
  Future<int> appendMessage({
    required String folderName,
    required String rawMimeBytes,
  }) async {
    _ensureConnected();
    final folder = _folder(folderName);
    final uid = ++_autoUid;
    final subject =
        _extractHeader(rawMimeBytes, 'subject') ?? '(appended message)';
    final fromAddress =
        _extractHeader(rawMimeBytes, 'from') ?? 'sender@example.org';
    folder.messages[uid] = _DemoMessage(
      envelope: MailEnvelope(
        uid: uid,
        subject: subject,
        fromAddress: fromAddress,
        receivedAt: DateTime.now(),
      ),
      body: MailBodyPayload(textPart: rawMimeBytes),
    );
    return uid;
  }

  @override
  Future<void> sendMessage({
    required String rawMimeBytes,
    required String fromAddress,
    required List<String> recipients,
  }) async {
    _ensureConnected();
    // The demo backend "sends" by appending the canonical sent copy to the
    // Sent folder. Live SMTP wire is exercised in the opt-in integration test.
    await appendMessage(folderName: 'Sent', rawMimeBytes: rawMimeBytes);
    sentLog.add(
      DemoSentRecord(
        fromAddress: fromAddress,
        recipients: List<String>.unmodifiable(recipients),
        rawMimeBytes: rawMimeBytes,
      ),
    );
  }

  @override
  Future<void> startIdle({
    required String folderName,
    required void Function(int uid) onEnvelope,
  }) async {
    // No-op for the demo backend; the test path that exercises push uses a
    // bespoke fake backend layered atop this one.
  }

  @override
  Future<void> stopIdle() async {}

  /// Visible to tests so they can assert what flowed through `sendMessage`.
  final List<DemoSentRecord> sentLog = <DemoSentRecord>[];

  String? _extractHeader(String rawMimeBytes, String name) {
    final pattern = RegExp(
      r'^' + RegExp.escape(name) + r':\s*(.+)$',
      caseSensitive: false,
      multiLine: true,
    );
    final match = pattern.firstMatch(rawMimeBytes);
    return match?.group(1)?.trim();
  }

  // ---- Helpers ----------------------------------------------------------

  void _ensureConnected() {
    if (_credentials == null) {
      throw const UnauthorizedError();
    }
  }

  _DemoFolder _folder(String name) {
    final folder = _folders[name];
    if (folder == null) {
      throw const NotFoundError();
    }
    return folder;
  }
}

class DemoSentRecord {
  const DemoSentRecord({
    required this.fromAddress,
    required this.recipients,
    required this.rawMimeBytes,
  });
  final String fromAddress;
  final List<String> recipients;
  final String rawMimeBytes;
}

class _DemoFolder {
  _DemoFolder({required this.name, this.specialUse});
  final String name;
  final String? specialUse;
  final Map<int, _DemoMessage> messages = <int, _DemoMessage>{};
}

class _DemoMessage {
  _DemoMessage({required this.envelope, required this.body});
  final MailEnvelope envelope;
  final MailBodyPayload body;

  _DemoMessage copyWithFlags({
    required bool seen,
    required bool flagged,
    required bool answered,
  }) {
    return _DemoMessage(
      envelope: envelope.copyWith(
        flags: MailFlags(seen: seen, flagged: flagged, answered: answered),
      ),
      body: body,
    );
  }
}

extension on MailEnvelope {
  MailEnvelope copyWith({int? uid, MailFlags? flags}) {
    return MailEnvelope(
      uid: uid ?? this.uid,
      subject: subject,
      fromAddress: fromAddress,
      toAddresses: toAddresses,
      ccAddresses: ccAddresses,
      bccAddresses: bccAddresses,
      receivedAt: receivedAt,
      messageIdHeader: messageIdHeader,
      inReplyTo: inReplyTo,
      referencesHeader: referencesHeader,
      snippet: snippet,
      flags: flags ?? this.flags,
      hasAttachments: hasAttachments,
    );
  }
}

Map<String, _DemoFolder> _defaultFolders() {
  final inbox = _DemoFolder(name: 'INBOX', specialUse: r'\Inbox');
  final sent = _DemoFolder(name: 'Sent', specialUse: r'\Sent');
  final drafts = _DemoFolder(name: 'Drafts', specialUse: r'\Drafts');
  final trash = _DemoFolder(name: 'Trash', specialUse: r'\Trash');
  final archive = _DemoFolder(name: 'Archive', specialUse: r'\Archive');

  // ---- Thread (3 messages) ---------------------------------------------
  const threadSubject = 'Suite-wide release timing';
  void putThreaded({
    required _DemoFolder folder,
    required int uid,
    required String from,
    required String text,
    required DateTime at,
    String? inReplyTo,
    String? references,
  }) {
    folder.messages[uid] = _DemoMessage(
      envelope: MailEnvelope(
        uid: uid,
        subject: 'Re: $threadSubject',
        fromAddress: from,
        receivedAt: at,
        messageIdHeader: '<msg-$uid@etabli.dev>',
        inReplyTo: inReplyTo,
        referencesHeader: references,
        snippet: text.substring(0, text.length.clamp(0, 80)),
      ),
      body: MailBodyPayload(textPart: text),
    );
  }

  inbox.messages[101] = _DemoMessage(
    envelope: MailEnvelope(
      uid: 101,
      subject: threadSubject,
      fromAddress: 'alice@etabli.dev',
      receivedAt: DateTime.utc(2026, 6, 20, 9),
      messageIdHeader: '<msg-101@etabli.dev>',
      snippet: 'Proposing a coordinated cut on the first Tuesday of the month.',
    ),
    body: const MailBodyPayload(
      textPart:
          'Proposing a coordinated cut on the first Tuesday of the month.'
          '\n\nThoughts welcome before Friday.',
    ),
  );
  putThreaded(
    folder: inbox,
    uid: 102,
    from: 'bob@etabli.dev',
    text: 'Works for me. Are we also coordinating store screenshots?',
    at: DateTime.utc(2026, 6, 20, 11),
    inReplyTo: '<msg-101@etabli.dev>',
    references: '<msg-101@etabli.dev>',
  );
  putThreaded(
    folder: inbox,
    uid: 103,
    from: 'alice@etabli.dev',
    text: 'Yes — Maestro gallery refresh lands the same day.',
    at: DateTime.utc(2026, 6, 20, 13),
    inReplyTo: '<msg-102@etabli.dev>',
    references: '<msg-101@etabli.dev> <msg-102@etabli.dev>',
  );

  // ---- HTML message with a remote image (render must NOT fetch) ---------
  inbox.messages[104] = _DemoMessage(
    envelope: MailEnvelope(
      uid: 104,
      subject: 'Q3 newsletter',
      fromAddress: 'newsletter@example.org',
      receivedAt: DateTime.utc(2026, 6, 21, 8),
      messageIdHeader: '<news-q3@example.org>',
      snippet: 'Big news this quarter — read on.',
    ),
    body: const MailBodyPayload(
      textPart: 'Big news this quarter — read on.',
      htmlPart:
          '<html><body>'
          '<h1>Q3 newsletter</h1>'
          '<p>Big news this quarter — read on.</p>'
          '<img src="https://tracker.example.org/pixel.gif" alt="tracker"/>'
          '<a href="https://example.org/article">Read more</a>'
          '<script>alert(1)</script>'
          '</body></html>',
    ),
  );

  // ---- Plain-text + attachment ----------------------------------------
  inbox.messages[105] = _DemoMessage(
    envelope: MailEnvelope(
      uid: 105,
      subject: 'Receipts attached',
      fromAddress: 'finance@example.org',
      receivedAt: DateTime.utc(2026, 6, 22, 16),
      hasAttachments: true,
    ),
    body: const MailBodyPayload(
      textPart: 'Attached are the Q2 receipts for review.',
      attachments: [
        MailAttachmentInfo(
          filename: 'receipts-q2.pdf',
          mimeType: 'application/pdf',
          sizeBytes: 184320,
        ),
      ],
    ),
  );

  // ---- One sent message --------------------------------------------------
  sent.messages[1] = _DemoMessage(
    envelope: MailEnvelope(
      uid: 1,
      subject: 'Hello world',
      fromAddress: 'me@etabli.dev',
      receivedAt: DateTime.utc(2026, 6, 19, 9),
    ),
    body: const MailBodyPayload(textPart: 'First sent message from courrier.'),
  );

  return {
    inbox.name: inbox,
    sent.name: sent,
    drafts.name: drafts,
    trash.name: trash,
    archive.name: archive,
  };
}
