import 'dart:async';

import 'package:enough_mail/enough_mail.dart';

import '../../../core/net/net_error.dart';
import 'mail_backend.dart';
import 'mail_credentials.dart';

// Real IMAP backend wrapping `enough_mail`'s ImapClient. Accepts either
// password or XOAUTH2 bearer credentials. Bounded per-folder window pulls
// envelopes + headers eagerly; bodies fetched lazily on open.
//
// CONDSTORE / QRESYNC is left aspirational for M6; M7 wires the incremental
// path. Errors map to NetError via mapHttpStatus-equivalent throws.

class ImapMailBackend implements MailBackend {
  ImapMailBackend({
    required this.host,
    this.port = 993,
    this.isSecure = true,
    this.smtpHost,
    this.smtpPort = 587,
    this.smtpUseStartTls = true,
    ImapClient? client,
    SmtpClient? smtp,
  }) : _client = client ?? ImapClient(),
       _smtp = smtp ?? SmtpClient('courrier');

  final String host;
  final int port;
  final bool isSecure;
  final String? smtpHost;
  final int smtpPort;
  final bool smtpUseStartTls;
  final ImapClient _client;
  final SmtpClient _smtp;

  String? _selectedFolder;
  Mailbox? _selectedMailbox;
  MailCredentials? _credentials;
  StreamSubscription<ImapEvent>? _idleEventSubscription;

  @override
  Future<void> connect(MailCredentials credentials) async {
    try {
      await _client.connectToServer(host, port, isSecure: isSecure);
      switch (credentials) {
        case PasswordCredentials():
          await _client.login(credentials.username, credentials.password);
        case XoauthBearerCredentials():
          await _client.authenticateWithOAuth2(
            credentials.username,
            credentials.accessToken,
          );
      }
      _credentials = credentials;
    } on ImapException catch (e) {
      throw UnauthorizedError(cause: e);
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _client.disconnect();
    } on ImapException {
      // Tearing down anyway — surface no error.
    }
  }

  @override
  Future<List<MailFolderHandle>> listFolders() async {
    final mailboxes = await _client.listMailboxes();
    return mailboxes
        .map(
          (m) => MailFolderHandle(
            name: m.path,
            specialUse: _specialUseFor(m),
            delimiter: m.pathSeparator,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<MailEnvelope>> fetchEnvelopes({
    required String folderName,
    int windowSize = 100,
  }) async {
    await _selectFolder(folderName);
    final mailbox = _selectedMailbox;
    if (mailbox == null || mailbox.messagesExists == 0) {
      return const <MailEnvelope>[];
    }
    final to = mailbox.messagesExists;
    final from = to - windowSize + 1 > 0 ? to - windowSize + 1 : 1;
    final messageSequence = MessageSequence.fromRange(from, to);
    final fetched = await _client.fetchMessages(
      messageSequence,
      'ENVELOPE FLAGS UID INTERNALDATE BODYSTRUCTURE',
    );
    return fetched.messages
        .map(_toEnvelope)
        .whereType<MailEnvelope>()
        .toList(growable: false);
  }

  @override
  Future<MailBodyPayload> fetchBody({
    required String folderName,
    required int uid,
  }) async {
    await _selectFolder(folderName);
    final sequence = MessageSequence.fromIds([uid], isUid: true);
    final fetched = await _client.fetchMessages(sequence, 'BODY[]');
    if (fetched.messages.isEmpty) {
      throw const NotFoundError();
    }
    final message = fetched.messages.first;
    final text = message.decodeTextPlainPart();
    final html = message.decodeTextHtmlPart();
    final attachments = <MailAttachmentInfo>[];
    for (final part in message.allPartsFlat) {
      final fileName = part.decodeFileName();
      if (fileName == null) {
        continue;
      }
      final mediaType = part.mediaType.text;
      final size = part.decodeContentBinary()?.length ?? 0;
      attachments.add(
        MailAttachmentInfo(
          filename: fileName,
          mimeType: mediaType,
          sizeBytes: size,
          contentId: part.getHeaderValue('content-id'),
        ),
      );
    }
    return MailBodyPayload(
      textPart: text,
      htmlPart: html,
      attachments: attachments,
    );
  }

  @override
  Future<void> applyFlags({
    required String folderName,
    required List<FlagUpdate> updates,
  }) async {
    await _selectFolder(folderName);
    for (final update in updates) {
      final sequence = MessageSequence.fromIds([update.uid], isUid: true);
      final flag = _flagToken(update.flag);
      if (update.value) {
        await _client.uidStore(sequence, [flag], action: StoreAction.add);
      } else {
        await _client.uidStore(sequence, [flag], action: StoreAction.remove);
      }
    }
  }

  @override
  Future<void> moveMessages({
    required String sourceFolder,
    required String destinationFolder,
    required List<int> uids,
  }) async {
    await _selectFolder(sourceFolder);
    final sequence = MessageSequence.fromIds(uids, isUid: true);
    await _client.uidMove(sequence, targetMailboxPath: destinationFolder);
  }

  @override
  Future<void> expungeTrash({required String trashFolderName}) async {
    await _selectFolder(trashFolderName);
    await _client.expunge();
  }

  @override
  Future<int> appendMessage({
    required String folderName,
    required String rawMimeBytes,
  }) async {
    await _selectFolder(folderName);
    final mime = MimeMessage.parseFromText(rawMimeBytes);
    await _client.appendMessage(mime, targetMailboxPath: folderName);
    // enough_mail doesn't surface the UID directly on append; the caller will
    // re-fetch envelopes after.
    return 0;
  }

  @override
  Future<void> sendMessage({
    required String rawMimeBytes,
    required String fromAddress,
    required List<String> recipients,
  }) async {
    final smtpHostName = smtpHost;
    if (smtpHostName == null) {
      throw StateError('SMTP host not configured on this backend');
    }
    final credentials = _credentials;
    if (credentials == null) {
      throw const UnauthorizedError();
    }
    try {
      await _smtp.connectToServer(
        smtpHostName,
        smtpPort,
        isSecure: !smtpUseStartTls,
      );
      if (smtpUseStartTls) {
        await _smtp.startTls();
      }
      switch (credentials) {
        case PasswordCredentials():
          await _smtp.authenticate(credentials.username, credentials.password);
        case XoauthBearerCredentials():
          await _smtp.authenticate(
            credentials.username,
            credentials.accessToken,
            AuthMechanism.xoauth2,
          );
      }
      final mime = MimeMessage.parseFromText(rawMimeBytes);
      await _smtp.sendMessage(
        mime,
        from: MailAddress('', fromAddress),
        recipients: recipients
            .map((r) => MailAddress('', r))
            .toList(growable: false),
      );
    } on SmtpException catch (e) {
      throw UnauthorizedError(cause: e);
    } finally {
      try {
        await _smtp.disconnect();
      } on SmtpException {
        // Tearing down anyway.
      }
    }
  }

  @override
  Future<void> startIdle({
    required String folderName,
    required void Function(int uid) onEnvelope,
  }) async {
    await _selectFolder(folderName);
    // enough_mail emits events on _client.eventBus; idleStart begins the
    // IDLE wait. The caller listens via the event bus stream.
    _idleEventSubscription = _client.eventBus.on<ImapEvent>().listen((event) {
      if (event is ImapFetchEvent) {
        final uid = event.message.uid;
        if (uid != null) {
          onEnvelope(uid);
        }
      }
    });
    await _client.idleStart();
  }

  @override
  Future<void> stopIdle() async {
    await _idleEventSubscription?.cancel();
    _idleEventSubscription = null;
    try {
      await _client.idleDone();
    } on ImapException {
      // The IDLE loop may have already terminated.
    }
  }

  // ---- Helpers ----------------------------------------------------------

  Future<void> _selectFolder(String name) async {
    if (_selectedFolder == name) {
      return;
    }
    _selectedMailbox = await _client.selectMailboxByPath(name);
    _selectedFolder = name;
  }

  MailEnvelope? _toEnvelope(MimeMessage m) {
    final uid = m.uid;
    if (uid == null) {
      return null;
    }
    return MailEnvelope(
      uid: uid,
      subject: m.decodeSubject(),
      fromAddress: m.fromEmail,
      receivedAt: m.decodeDate() ?? DateTime.now(),
      messageIdHeader: m.getHeaderValue('message-id'),
      inReplyTo: m.getHeaderValue('in-reply-to'),
      referencesHeader: m.getHeaderValue('references'),
      toAddresses: m.to?.map((a) => a.email).join(', '),
      ccAddresses: m.cc?.map((a) => a.email).join(', '),
      flags: MailFlags(
        seen: m.isSeen,
        flagged: m.isFlagged,
        answered: m.isAnswered,
      ),
      hasAttachments: m.hasAttachments(),
    );
  }

  String _specialUseFor(Mailbox m) {
    if (m.isInbox) {
      return r'\Inbox';
    }
    if (m.isSent) {
      return r'\Sent';
    }
    if (m.isDrafts) {
      return r'\Drafts';
    }
    if (m.isTrash) {
      return r'\Trash';
    }
    if (m.isArchive) {
      return r'\Archive';
    }
    if (m.isJunk) {
      return r'\Junk';
    }
    return '';
  }

  String _flagToken(String name) {
    switch (name) {
      case 'seen':
        return r'\Seen';
      case 'flagged':
        return r'\Flagged';
      case 'answered':
        return r'\Answered';
    }
    return name;
  }
}
