import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_reader.dart';
import '../../../core/ical/ical_writer.dart';
import 'event_draft.dart';
import 'event_serializer.dart';

// Offline-first calendar repository. Every read/write goes through CourrierDatabase
// first (AUDIT_LOOP dim 6). Sync happens via the M2 DAV layer through
// CalendarSyncBackend; this repo is the canonical local source of truth.

class CalendarRepository {
  CalendarRepository({
    required this.db,
    EventSerializer? serializer,
    String Function()? uidGenerator,
  }) : _serializer = serializer ?? const EventSerializer(),
       _uidGenerator = uidGenerator ?? _defaultUidGenerator;

  final CourrierDatabase db;
  final EventSerializer _serializer;
  final String Function() _uidGenerator;

  static const IcalReader _reader = IcalReader();
  static const IcalWriter _writer = IcalWriter();

  // ---- CRUD ---------------------------------------------------------------

  Future<int> createEvent(EventDraft draft) async {
    final uid = draft.uid ?? _uidGenerator();
    final ics = _serializer.renderIcs(draft, uid: uid);
    final eventId = await db
        .into(db.calendarEvents)
        .insert(
          CalendarEventsCompanion.insert(
            collectionId: draft.collectionId,
            uid: uid,
            summary: Value(draft.summary),
            location: Value(draft.location),
            description: Value(draft.description),
            dtstart: Value(draft.start),
            dtend: Value(draft.end),
            allDay: Value(draft.allDay),
            rrule: Value(draft.rrule),
            organizer: Value(draft.organizer),
            attendeesJson: Value(_encodeAttendees(draft.attendees)),
            rawIcs: ics,
          ),
        );
    await _replaceReminders(eventId, draft);
    await _replaceExdates(eventId, draft.exdates);
    await _enqueueChange(
      accountId: await _accountIdForCollection(draft.collectionId),
      eventId: eventId,
      operation: 'create',
      payload: ics,
    );
    return eventId;
  }

  Future<void> updateEvent(int eventId, EventDraft draft) async {
    final existing = await (db.select(
      db.calendarEvents,
    )..where((t) => t.id.equals(eventId))).getSingleOrNull();
    if (existing == null) {
      throw StateError('Event $eventId not found');
    }
    final uid = existing.uid;
    final ics = _serializer.renderIcs(draft.copyWith(), uid: uid);
    await (db.update(
      db.calendarEvents,
    )..where((t) => t.id.equals(eventId))).write(
      CalendarEventsCompanion(
        summary: Value(draft.summary),
        location: Value(draft.location),
        description: Value(draft.description),
        dtstart: Value(draft.start),
        dtend: Value(draft.end),
        allDay: Value(draft.allDay),
        rrule: Value(draft.rrule),
        organizer: Value(draft.organizer),
        attendeesJson: Value(_encodeAttendees(draft.attendees)),
        rawIcs: Value(ics),
        lastModified: Value(DateTime.now()),
      ),
    );
    await _replaceReminders(eventId, draft);
    await _replaceExdates(eventId, draft.exdates);
    await _enqueueChange(
      accountId: await _accountIdForCollection(draft.collectionId),
      eventId: eventId,
      operation: 'update',
      payload: ics,
      baseEtag: existing.etag,
    );
  }

  Future<void> deleteEvent(int eventId) async {
    final existing = await (db.select(
      db.calendarEvents,
    )..where((t) => t.id.equals(eventId))).getSingleOrNull();
    if (existing == null) {
      return;
    }
    await (db.update(db.calendarEvents)..where((t) => t.id.equals(eventId)))
        .write(const CalendarEventsCompanion(deletedLocally: Value(true)));
    await _enqueueChange(
      accountId: await _accountIdForCollection(existing.collectionId),
      eventId: eventId,
      operation: 'delete',
      baseEtag: existing.etag,
    );
  }

  // ---- Recurrence: delete-occurrence (M3 spec) ----------------------------

  /// Add an EXDATE so a single occurrence stops appearing.
  Future<void> deleteOccurrence(int eventId, DateTime occurrence) async {
    await db
        .into(db.eventRecurrenceOverrides)
        .insert(
          EventRecurrenceOverridesCompanion.insert(
            eventId: eventId,
            kind: 'EXDATE',
            value: _formatUtcIcsDate(occurrence),
          ),
        );
    await _rerenderIcsForEvent(eventId);
  }

  /// "This and following" — truncate the RRULE with UNTIL = occurrence - 1 sec.
  Future<void> deleteThisAndFollowing(int eventId, DateTime occurrence) async {
    final existing = await (db.select(
      db.calendarEvents,
    )..where((t) => t.id.equals(eventId))).getSingleOrNull();
    if (existing == null || existing.rrule == null) {
      return;
    }
    final cutoff = occurrence.subtract(const Duration(seconds: 1)).toUtc();
    final truncatedRrule = _appendUntil(existing.rrule!, cutoff);
    await (db.update(db.calendarEvents)..where((t) => t.id.equals(eventId)))
        .write(CalendarEventsCompanion(rrule: Value(truncatedRrule)));
    await _rerenderIcsForEvent(eventId);
  }

  /// "All" — same as deleteEvent.
  Future<void> deleteAllOccurrences(int eventId) => deleteEvent(eventId);

  // ---- Queries ------------------------------------------------------------

  Future<List<CalendarEvent>> eventsBetween({
    required DateTime from,
    required DateTime to,
    int? collectionId,
  }) async {
    final query = db.select(db.calendarEvents)
      ..where((t) => t.deletedLocally.equals(false))
      ..where((t) => t.dtstart.isBetweenValues(from, to))
      ..orderBy([(t) => OrderingTerm.asc(t.dtstart)]);
    if (collectionId != null) {
      query.where((t) => t.collectionId.equals(collectionId));
    }
    return query.get();
  }

  Future<List<EventReminder>> remindersFor(int eventId) async {
    return (db.select(
      db.eventReminders,
    )..where((t) => t.eventId.equals(eventId))).get();
  }

  Stream<List<CalendarEvent>> watchUpcoming({int limit = 50}) {
    return (db.select(db.calendarEvents)
          ..where((t) => t.deletedLocally.equals(false))
          ..where((t) => t.dtstart.isBiggerOrEqualValue(DateTime.now()))
          ..orderBy([(t) => OrderingTerm.asc(t.dtstart)])
          ..limit(limit))
        .watch();
  }

  // ---- Internals ----------------------------------------------------------

  Future<void> _replaceReminders(int eventId, EventDraft draft) async {
    await (db.delete(
      db.eventReminders,
    )..where((t) => t.eventId.equals(eventId))).go();
    for (final reminder in draft.reminders) {
      await db
          .into(db.eventReminders)
          .insert(
            EventRemindersCompanion.insert(
              eventId: eventId,
              minutesBeforeStart: Value(reminder.minutesBeforeStart),
              absoluteTrigger: Value(reminder.absoluteTrigger),
              action: Value(reminder.action),
              label: Value(reminder.label),
            ),
          );
    }
  }

  Future<void> _replaceExdates(int eventId, List<String> exdates) async {
    await (db.delete(
      db.eventRecurrenceOverrides,
    )..where((t) => t.eventId.equals(eventId) & t.kind.equals('EXDATE'))).go();
    for (final value in exdates) {
      await db
          .into(db.eventRecurrenceOverrides)
          .insert(
            EventRecurrenceOverridesCompanion.insert(
              eventId: eventId,
              kind: 'EXDATE',
              value: value,
            ),
          );
    }
  }

  /// After recurrence edits, surgically patch the cached raw ICS — preserves
  /// unknown vendor properties (audit dim 7) because we round-trip through
  /// the M2 reader/writer rather than re-render from scratch.
  Future<void> _rerenderIcsForEvent(int eventId) async {
    final existing = await (db.select(
      db.calendarEvents,
    )..where((t) => t.id.equals(eventId))).getSingleOrNull();
    if (existing == null) {
      return;
    }
    final tree = _reader.parse(existing.rawIcs);
    final vevent = tree.firstChild('VEVENT');
    if (vevent == null) {
      return;
    }

    vevent.removeAll('RRULE');
    if (existing.rrule != null) {
      vevent.properties.add(
        IcalProperty(name: 'RRULE', value: existing.rrule!),
      );
    }

    final overrides = await (db.select(
      db.eventRecurrenceOverrides,
    )..where((t) => t.eventId.equals(eventId) & t.kind.equals('EXDATE'))).get();
    vevent.removeAll('EXDATE');
    for (final override in overrides) {
      vevent.properties.add(
        IcalProperty(name: 'EXDATE', value: override.value),
      );
    }

    final ics = _writer.render(tree);
    await (db.update(
      db.calendarEvents,
    )..where((t) => t.id.equals(eventId))).write(
      CalendarEventsCompanion(
        rawIcs: Value(ics),
        lastModified: Value(DateTime.now()),
      ),
    );
    await _enqueueChange(
      accountId: await _accountIdForCollection(existing.collectionId),
      eventId: eventId,
      operation: 'update',
      payload: ics,
      baseEtag: existing.etag,
    );
  }

  Future<int> _accountIdForCollection(int collectionId) async {
    final c = await (db.select(
      db.collections,
    )..where((t) => t.id.equals(collectionId))).getSingle();
    return c.accountId;
  }

  Future<void> _enqueueChange({
    required int accountId,
    required int eventId,
    required String operation,
    String? payload,
    String? baseEtag,
  }) async {
    await db
        .into(db.pendingChanges)
        .insert(
          PendingChangesCompanion.insert(
            accountId: accountId,
            entityTable: 'calendar_events',
            entityId: eventId,
            operation: operation,
            baseEtag: Value(baseEtag),
            payload: Value(payload),
          ),
        );
  }

  String? _encodeAttendees(List<String> attendees) {
    if (attendees.isEmpty) {
      return null;
    }
    return attendees.join('\n');
  }

  String _formatUtcIcsDate(DateTime dt) {
    final utc = dt.toUtc();
    final yyyy = utc.year.toString().padLeft(4, '0');
    final mm = utc.month.toString().padLeft(2, '0');
    final dd = utc.day.toString().padLeft(2, '0');
    final hh = utc.hour.toString().padLeft(2, '0');
    final mi = utc.minute.toString().padLeft(2, '0');
    final ss = utc.second.toString().padLeft(2, '0');
    return '$yyyy$mm${dd}T$hh$mi${ss}Z';
  }

  String _appendUntil(String rrule, DateTime cutoff) {
    final withoutUntil = rrule
        .split(';')
        .where((part) => !part.toUpperCase().startsWith('UNTIL='))
        .where((part) => !part.toUpperCase().startsWith('COUNT='))
        .join(';');
    return '$withoutUntil;UNTIL=${_formatUtcIcsDate(cutoff)}';
  }
}

int _uidCounter = 0;
String _defaultUidGenerator() {
  final now = DateTime.now().toUtc();
  // millisecond + microsecond + process-local counter — keeps the UID unique
  // even when many creates happen inside the same millisecond.
  return '${now.millisecondsSinceEpoch}-${now.microsecond}-${++_uidCounter}'
      '@etabli.dev';
}
