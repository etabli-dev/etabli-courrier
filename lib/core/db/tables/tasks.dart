import 'package:drift/drift.dart';

import 'accounts.dart';

// VTODO. Subtasks are modelled via RELATED-TO;RELTYPE=PARENT — stored as a
// parentUid string so subtask relations survive sync even when the parent row
// has not yet been pulled.
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();

  TextColumn get uid => text()();
  TextColumn get etag => text().nullable()();

  TextColumn get summary => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get due => dateTime().nullable()();
  DateTimeColumn get completed => dateTime().nullable()();
  IntColumn get percentComplete => integer().nullable()();
  IntColumn get priority => integer().nullable()();

  // Recurrence — RRULE for fixed schedules, repeatAfterCompletion captures
  // Tasks.org-style "every N days from completion".
  TextColumn get rrule => text().nullable()();
  BoolColumn get repeatAfterCompletion =>
      boolean().withDefault(const Constant(false))();

  // RELATED-TO;RELTYPE=PARENT — pointer to the parent VTODO's UID.
  TextColumn get parentUid => text().nullable()();

  TextColumn get rawIcs => text()();

  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get deletedLocally =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {collectionId, uid},
  ];
}
