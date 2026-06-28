import 'package:drift/drift.dart';

import 'accounts.dart';

// VEVENT row. Stores opaque ICS so round-trip preserves unknown properties
// (AUDIT_LOOP dim 7 data-model fidelity). Indexed fields are populated from a
// pure parse of the ICS during insertion, but the source of truth remains the
// raw bytes.
class CalendarEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();

  // Server identity vs object identity — UID is stable, etag changes per write.
  TextColumn get uid => text()();
  TextColumn get etag => text().nullable()();

  TextColumn get summary => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dtstart => dateTime().nullable()();
  DateTimeColumn get dtend => dateTime().nullable()();
  BoolColumn get allDay => boolean().withDefault(const Constant(false))();

  // RRULE source so the human-readable formatter at M3 can re-render.
  TextColumn get rrule => text().nullable()();

  TextColumn get organizer => text().nullable()();
  TextColumn get attendeesJson => text().nullable()();

  // Raw ICS — read on PUT to preserve unknown properties.
  TextColumn get rawIcs => text()();

  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();
  // Tombstone for pending deletes (offline-first).
  BoolColumn get deletedLocally =>
      boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {collectionId, uid},
  ];
}

// N reminders per event — explicit one-to-many table (BUILD_PROMPT M1 +
// addendum from Fossify learning).
class EventReminders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId =>
      integer().references(CalendarEvents, #id, onDelete: KeyAction.cascade)();

  // Either an offset relative to dtstart...
  IntColumn get minutesBeforeStart => integer().nullable()();
  // ...or an absolute trigger.
  DateTimeColumn get absoluteTrigger => dateTime().nullable()();

  // VALARM action — DISPLAY / AUDIO / EMAIL etc. Stored as text to keep
  // forward-compat.
  TextColumn get action => text().withDefault(const Constant('DISPLAY'))();
  TextColumn get label => text().nullable()();
}

// RECURRENCE-ID overrides + EXDATE dates kept verbatim so we can re-emit on PUT.
class EventRecurrenceOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventId =>
      integer().references(CalendarEvents, #id, onDelete: KeyAction.cascade)();

  // 'EXDATE' or 'RECURRENCE-ID'
  TextColumn get kind => text()();
  TextColumn get value => text()();
}
