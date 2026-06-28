import 'package:drift/drift.dart';

import 'accounts.dart';

// Outbound change queue. Every local mutation that needs to reach a remote
// lands here first; the sync engine drains it idempotently.
class PendingChanges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  // 'event' | 'contact' | 'task' | 'note' | 'feed_item' | 'mail_flag' | ...
  TextColumn get entityTable => text()();
  IntColumn get entityId => integer()();

  // 'create' | 'update' | 'delete'
  TextColumn get operation => text()();

  // Etag observed at the moment we queued the change — used for the If-Match
  // guard on PUT (DAV 412 surface) so we never overwrite an unseen server edit.
  TextColumn get baseEtag => text().nullable()();

  // Optional opaque payload (JSON/ICS bytes) so a delayed flush works after
  // restart without re-reading the entity row.
  TextColumn get payload => text().nullable()();

  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Surfaced conflicts the user must resolve. Created by the sync engine when
// last-write-wins would clobber server state we have no way of merging.
class SyncConflicts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().references(Accounts, #id, onDelete: KeyAction.cascade)();

  TextColumn get entityTable => text()();
  IntColumn get entityId => integer()();

  TextColumn get localPayload => text()();
  TextColumn get serverPayload => text()();
  TextColumn get serverEtag => text().nullable()();

  // Set when the user (or auto-policy) makes a choice. See
  // core/sync/conflict_resolver.dart for the enum values.
  TextColumn get resolution => text().nullable()();
  DateTimeColumn get detectedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
}
