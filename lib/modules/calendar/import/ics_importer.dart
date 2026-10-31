import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/ical/ical_component.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_reader.dart';
import '../../../core/ical/ical_writer.dart';
import '../../../core/ical/vevent.dart';
import '../../../core/recurrence/ical_date.dart';

// Read a .ics file (or string), iterate VEVENTs, upsert each into the named
// local-only collection. Idempotent: re-import of the same file with the same
// UIDs updates the existing rows rather than duplicating.
//
// The canonical raw ICS stored per row is a one-VEVENT VCALENDAR carrying
// the original calendar-level properties (PRODID, VERSION, X-WR-CALNAME …) so
// unknown props survive (audit dim 7).

class IcsImporter {
  IcsImporter({required this.db});

  final CourrierDatabase db;

  static const IcalReader _reader = IcalReader();
  static const IcalWriter _writer = IcalWriter();
  static const IcalDateParser _dateParser = IcalDateParser();

  /// Returns the number of events upserted.
  Future<int> importVcalendar({
    required int collectionId,
    required String contents,
  }) async {
    final tree = _reader.parse(contents);
    if (tree.name != 'VCALENDAR') {
      throw const FormatException('ICS root must be VCALENDAR');
    }

    final calendarHeader = _captureCalendarHeader(tree);

    final grouped = <String, List<IcalComponent>>{};
    for (final event in tree.childrenOf('VEVENT')) {
      final uid = event.get('UID')?.value;
      if (uid == null || uid.isEmpty) {
        throw const FormatException('VEVENT missing UID');
      }
      grouped.putIfAbsent(uid, () => []).add(event);
    }
    var upserted = 0;
    await db.transaction(() async {
      for (final events in grouped.values) {
        final master =
            events.where((e) => e.get('RECURRENCE-ID') == null).firstOrNull ??
            events.first;
        await _upsertVevent(
          collectionId: collectionId,
          header: calendarHeader,
          vevent: master,
          retainedComponents: [
            ...tree.children.where((c) => c.name != 'VEVENT'),
            ...events,
          ],
        );
        upserted++;
      }
    });
    return upserted;
  }

  List<IcalProperty> _captureCalendarHeader(IcalComponent vcalendar) {
    // Preserve calendar properties; grouped recurrence overrides and timezone
    // definitions are retained alongside the master event below.
    return List<IcalProperty>.unmodifiable(vcalendar.properties);
  }

  Future<void> _upsertVevent({
    required int collectionId,
    required List<IcalProperty> header,
    required IcalComponent vevent,
    required List<IcalComponent> retainedComponents,
  }) async {
    final lens = VEvent.from(vevent);
    final uid = lens.uid;
    if (uid == null || uid.isEmpty) {
      throw const FormatException('VEVENT missing UID');
    }

    final dtstart = _maybeParseDate(vevent, 'DTSTART');
    final dtend = _maybeParseDate(vevent, 'DTEND');
    final allDay = vevent.get('DTSTART')?.param('VALUE') == 'DATE';

    final canonical = IcalComponent('VCALENDAR')
      ..properties.addAll(header)
      ..children.addAll(retainedComponents);
    final canonicalIcs = _writer.render(canonical);

    final existing =
        await (db.select(db.calendarEvents)..where(
              (t) => t.collectionId.equals(collectionId) & t.uid.equals(uid),
            ))
            .getSingleOrNull();

    if (existing == null) {
      await db
          .into(db.calendarEvents)
          .insert(
            CalendarEventsCompanion.insert(
              collectionId: collectionId,
              uid: uid,
              summary: Value(lens.summary),
              location: Value(lens.location),
              description: Value(lens.description),
              dtstart: Value(dtstart),
              dtend: Value(dtend),
              allDay: Value(allDay),
              rrule: Value(lens.rrule),
              organizer: Value(lens.organizer),
              rawIcs: canonicalIcs,
            ),
          );
      return;
    }

    await (db.update(
      db.calendarEvents,
    )..where((t) => t.id.equals(existing.id))).write(
      CalendarEventsCompanion(
        summary: Value(lens.summary),
        location: Value(lens.location),
        description: Value(lens.description),
        dtstart: Value(dtstart),
        dtend: Value(dtend),
        allDay: Value(allDay),
        rrule: Value(lens.rrule),
        organizer: Value(lens.organizer),
        rawIcs: Value(canonicalIcs),
        lastModified: Value(DateTime.now()),
      ),
    );
  }

  DateTime? _maybeParseDate(IcalComponent vevent, String propName) {
    final prop = vevent.get(propName);
    if (prop == null) {
      return null;
    }
    return _dateParser
        .parse(
          prop.value,
          valueParam: prop.param('VALUE'),
          tzidParam: prop.param('TZID'),
        )
        .toDateTime();
  }
}
