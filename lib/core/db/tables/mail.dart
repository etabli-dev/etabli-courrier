import 'package:drift/drift.dart';

import 'accounts.dart';

// Mail folder mirror. Special-use flags (\Inbox, \Sent, \Drafts, \Trash,
// \Archive, \Junk) survive in `specialUse` so the UI can pick the right icon
// without rescanning XLIST/SPECIAL-USE on each open.
class MailFolders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get name => text()();
  TextColumn get specialUse => text().nullable()();
  TextColumn get delimiter => text().nullable()();

  // CONDSTORE/QRESYNC handles. Updated whenever we observe them.
  IntColumn get uidValidity => integer().nullable()();
  IntColumn get uidNext => integer().nullable()();
  IntColumn get highestModseq => integer().nullable()();

  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {accountId, name},
  ];
}

class MailMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get folderId =>
      integer().references(MailFolders, #id, onDelete: KeyAction.cascade)();

  IntColumn get uid => integer()();
  TextColumn get messageIdHeader => text().nullable()();
  TextColumn get inReplyTo => text().nullable()();
  TextColumn get referencesHeader => text().nullable()();

  TextColumn get subject => text().nullable()();
  TextColumn get fromAddress => text().nullable()();
  TextColumn get toAddresses => text().nullable()();
  TextColumn get ccAddresses => text().nullable()();
  TextColumn get bccAddresses => text().nullable()();
  DateTimeColumn get sentAt => dateTime().nullable()();

  // IMAP flags + lazy-fetch state.
  BoolColumn get seen => boolean().withDefault(const Constant(false))();
  BoolColumn get flagged => boolean().withDefault(const Constant(false))();
  BoolColumn get answered => boolean().withDefault(const Constant(false))();
  BoolColumn get hasAttachments =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get bodyDownloaded =>
      boolean().withDefault(const Constant(false))();
  // Remote-content reveal: stays false unless the user explicitly reveals
  // for that message (M6 read path).
  BoolColumn get remoteContentAllowed =>
      boolean().withDefault(const Constant(false))();

  TextColumn get snippet => text().nullable()();
  TextColumn get bodyText => text().nullable()();
  TextColumn get bodyHtml => text().nullable()();

  // Trash semantics: tombstone before EXPUNGE on empty-trash (M6).
  BoolColumn get trashed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get trashedAt => dateTime().nullable()();

  DateTimeColumn get receivedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {folderId, uid},
  ];
}

class MailAttachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get messageId =>
      integer().references(MailMessages, #id, onDelete: KeyAction.cascade)();

  TextColumn get filename => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  TextColumn get contentId => text().nullable()();
  TextColumn get localPath => text().nullable()();
  BoolColumn get downloaded => boolean().withDefault(const Constant(false))();
}
