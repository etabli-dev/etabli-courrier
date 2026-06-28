import 'package:meta/meta.dart';

import 'mail_credentials.dart';

// Backend-shaped surface every mail provider exposes. The IMAP backend
// (M6) and the M365 OAuth-IMAP backend (M8) implement this; the in-memory
// demo backend implements it for tests + sample content (M13/M14).
//
// Everything is plain Dart on purpose — the MailRepository upstream wires
// each call into drift writes.

@immutable
class MailFolderHandle {
  const MailFolderHandle({required this.name, this.specialUse, this.delimiter});
  final String name;
  final String? specialUse; // \Inbox, \Sent, \Drafts, \Trash, \Archive, \Junk
  final String? delimiter;
}

@immutable
class MailEnvelope {
  const MailEnvelope({
    required this.uid,
    required this.subject,
    required this.fromAddress,
    required this.receivedAt,
    this.messageIdHeader,
    this.inReplyTo,
    this.referencesHeader,
    this.toAddresses,
    this.ccAddresses,
    this.bccAddresses,
    this.snippet,
    this.flags = const MailFlags(),
    this.hasAttachments = false,
  });

  final int uid;
  final String? subject;
  final String? fromAddress;
  final String? toAddresses;
  final String? ccAddresses;
  final String? bccAddresses;
  final DateTime receivedAt;
  final String? messageIdHeader;
  final String? inReplyTo;
  final String? referencesHeader;
  final String? snippet;
  final MailFlags flags;
  final bool hasAttachments;
}

@immutable
class MailFlags {
  const MailFlags({
    this.seen = false,
    this.flagged = false,
    this.answered = false,
  });
  final bool seen;
  final bool flagged;
  final bool answered;
}

@immutable
class MailBodyPayload {
  const MailBodyPayload({
    this.textPart,
    this.htmlPart,
    this.attachments = const <MailAttachmentInfo>[],
  });
  final String? textPart;
  final String? htmlPart;
  final List<MailAttachmentInfo> attachments;
}

@immutable
class MailAttachmentInfo {
  const MailAttachmentInfo({
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    this.contentId,
  });
  final String filename;
  final String mimeType;
  final int sizeBytes;
  final String? contentId;
}

// One per UID we want to flip between true/false.
@immutable
class FlagUpdate {
  const FlagUpdate({
    required this.uid,
    required this.flag,
    required this.value,
  });
  final int uid;
  final String flag; // 'seen' | 'flagged' | 'answered'
  final bool value;
}

abstract class MailBackend {
  /// Open a session. Implementations may reuse a long-lived connection.
  Future<void> connect(MailCredentials credentials);

  /// Close the session and release sockets.
  Future<void> disconnect();

  /// All mailboxes the user can see, including special-use folders.
  Future<List<MailFolderHandle>> listFolders();

  /// Bounded window of newest envelopes — headers + envelope only. Bodies
  /// are fetched lazily by `fetchBody`.
  Future<List<MailEnvelope>> fetchEnvelopes({
    required String folderName,
    int windowSize = 100,
  });

  /// Eagerly fetch full body + attachment metadata for a single message.
  Future<MailBodyPayload> fetchBody({
    required String folderName,
    required int uid,
  });

  /// Apply flag updates in batch. Implementations may batch the wire calls.
  Future<void> applyFlags({
    required String folderName,
    required List<FlagUpdate> updates,
  });

  /// Move messages between folders (used for Trash + Archive + Restore).
  Future<void> moveMessages({
    required String sourceFolder,
    required String destinationFolder,
    required List<int> uids,
  });

  /// Permanently delete tombstoned messages in the trash folder.
  Future<void> expungeTrash({required String trashFolderName});

  /// Append a message (used for compose drafts + sent copies in M7).
  Future<int> appendMessage({
    required String folderName,
    required String rawMimeBytes,
  });

  /// Send a message via SMTP (M7).
  Future<void> sendMessage({
    required String rawMimeBytes,
    required String fromAddress,
    required List<String> recipients,
  });

  /// Begin idle/push listening (M7). Implementations stream new envelope hints
  /// through [onEnvelope] until [stopIdle] is called. Implementations that
  /// don't support push are free to short-circuit immediately.
  Future<void> startIdle({
    required String folderName,
    required void Function(int uid) onEnvelope,
  }) async {}

  Future<void> stopIdle() async {}
}
