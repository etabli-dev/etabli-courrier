import 'package:drift/drift.dart';

import 'accounts.dart';

class ContactCards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();

  TextColumn get uid => text()();
  TextColumn get etag => text().nullable()();

  TextColumn get formattedName => text().nullable()();
  TextColumn get givenName => text().nullable()();
  TextColumn get familyName => text().nullable()();
  TextColumn get organization => text().nullable()();
  TextColumn get primaryEmail => text().nullable()();
  TextColumn get primaryPhone => text().nullable()();

  // Raw VCARD — preserves unknown properties on round-trip (dim 7).
  TextColumn get rawVcard => text()();
  // Optional bundled photo handle.
  TextColumn get photoRef => text().nullable()();

  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deletedLocally =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {collectionId, uid},
  ];
}

class ContactGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
}

class ContactGroupMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId =>
      integer().references(ContactGroups, #id, onDelete: KeyAction.cascade)();
  IntColumn get contactId =>
      integer().references(ContactCards, #id, onDelete: KeyAction.cascade)();
}
