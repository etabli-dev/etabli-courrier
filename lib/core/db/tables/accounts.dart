import 'package:drift/drift.dart';

// Account kinds. Local-only accounts are first-class (PREFLIGHT, M1 scope).
//   * nextcloud — DAV + Notes + News
//   * imap      — IMAP/SMTP mailbox (M6+)
//   * m365      — Microsoft 365 mail via XOAUTH2 (M8)
//   * local     — no remote endpoint; bundled sample / holiday ICS / scratch
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => text()();
  TextColumn get displayName => text()();
  TextColumn get baseUrl => text().nullable()();
  TextColumn get username => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Optional pointer into flutter_secure_storage for the per-account credential
  // bundle. Never holds the credential itself.
  TextColumn get secretsRef => text().nullable()();
}

// Synced collection (calendar, addressbook, tasklist, notes folder, news feed
// folder, mail folder). Used for every kind to keep sync uniform.
class Collections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();
  TextColumn get remoteHref => text().nullable()();
  TextColumn get displayName => text()();
  // DAV named props the audit checks for (calendar-color, sync-token, ctag).
  // Stored opaquely as strings; named getters live in the repos.
  TextColumn get color => text().nullable()();
  TextColumn get ctag => text().nullable()();
  TextColumn get syncToken => text().nullable()();
  // Per-collection sync window cap (mail bounded-window policy).
  IntColumn get windowSize => integer().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
