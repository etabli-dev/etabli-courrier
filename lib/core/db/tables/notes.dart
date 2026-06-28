import 'package:drift/drift.dart';

import 'accounts.dart';

// Nextcloud Notes REST records. M9 builds the sync. We model the API's
// concepts now so M9 is a thin filler.
class NoteItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();

  // Remote Notes API id (when present).
  TextColumn get remoteId => text().nullable()();
  TextColumn get etag => text().nullable()();

  TextColumn get title => text()();
  TextColumn get category => text().nullable()();
  TextColumn get content => text()();
  // 'text' or 'checklist'. Checklist <-> markdown task lists at M9.
  TextColumn get kind => text().withDefault(const Constant('text'))();
  BoolColumn get favorite => boolean().withDefault(const Constant(false))();
  BoolColumn get locked => boolean().withDefault(const Constant(false))();

  DateTimeColumn get modified => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deletedLocally =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {collectionId, remoteId},
  ];
}
