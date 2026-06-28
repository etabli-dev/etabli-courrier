import '../../../core/ical/ical_component.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_writer.dart';
import 'event_draft.dart';

// Build a VCALENDAR > VEVENT tree from an EventDraft. The serializer is
// deliberately tiny: anything we don't model lives in the underlying
// IcalComponent (preserved on round-trip via the M2 reader/writer).
//
// When the repository updates an existing event whose raw ICS already exists,
// it merges in place rather than calling this — that way unknown vendor
// properties survive. This function only runs on fresh creates.

class EventSerializer {
  const EventSerializer({this.prodId = '-//Etabli//courrier 0.1.0//EN'});

  final String prodId;

  String renderIcs(EventDraft draft, {required String uid}) {
    final vcal = IcalComponent('VCALENDAR')
      ..properties.addAll([
        IcalProperty(name: 'VERSION', value: '2.0'),
        IcalProperty(name: 'PRODID', value: prodId),
      ]);

    final vevent = IcalComponent('VEVENT')
      ..properties.addAll([
        IcalProperty(name: 'UID', value: uid),
        IcalProperty(
          name: 'DTSTAMP',
          value: _formatUtc(DateTime.now().toUtc()),
        ),
        if (draft.allDay)
          IcalProperty(
            name: 'DTSTART',
            parameters: const {
              'VALUE': ['DATE'],
            },
            value: _formatDate(draft.start),
          )
        else
          IcalProperty(name: 'DTSTART', value: _formatUtc(draft.start.toUtc())),
        if (draft.allDay)
          IcalProperty(
            name: 'DTEND',
            parameters: const {
              'VALUE': ['DATE'],
            },
            value: _formatDate(draft.end),
          )
        else
          IcalProperty(name: 'DTEND', value: _formatUtc(draft.end.toUtc())),
        IcalProperty(name: 'SUMMARY', value: draft.summary),
        if (draft.location != null)
          IcalProperty(name: 'LOCATION', value: draft.location!),
        if (draft.description != null)
          IcalProperty(name: 'DESCRIPTION', value: draft.description!),
        if (draft.rrule != null)
          IcalProperty(name: 'RRULE', value: draft.rrule!),
        for (final exdate in draft.exdates)
          IcalProperty(name: 'EXDATE', value: exdate),
        if (draft.organizer != null)
          IcalProperty(name: 'ORGANIZER', value: draft.organizer!),
        for (final attendee in draft.attendees)
          IcalProperty(name: 'ATTENDEE', value: attendee),
      ]);

    for (final reminder in draft.reminders) {
      final valarm = IcalComponent('VALARM')
        ..properties.addAll([
          IcalProperty(name: 'ACTION', value: reminder.action),
          if (reminder.minutesBeforeStart != null)
            IcalProperty(
              name: 'TRIGGER',
              value: '-PT${reminder.minutesBeforeStart}M',
            )
          else if (reminder.absoluteTrigger != null)
            IcalProperty(
              name: 'TRIGGER',
              parameters: const {
                'VALUE': ['DATE-TIME'],
              },
              value: _formatUtc(reminder.absoluteTrigger!.toUtc()),
            ),
          if (reminder.label != null)
            IcalProperty(name: 'DESCRIPTION', value: reminder.label!),
        ]);
      vevent.children.add(valarm);
    }

    vcal.children.add(vevent);
    return const IcalWriter().render(vcal);
  }

  String _formatUtc(DateTime dt) {
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return '$yyyy$mm${dd}T$hh$min${ss}Z';
  }

  String _formatDate(DateTime dt) {
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '$yyyy$mm$dd';
  }
}
