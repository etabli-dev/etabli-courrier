import 'ical_component.dart';

// Typed lens on an IcalComponent whose name is VEVENT. We do NOT copy the
// data into a new struct — we wrap the component so any field we don't model
// (X-* / unknown) is still present when the writer renders.

class VEvent {
  VEvent.from(this.component)
    : assert(component.name == 'VEVENT', 'VEvent must wrap a VEVENT component');

  final IcalComponent component;

  String? get uid => component.get('UID')?.value;
  String? get summary => component.get('SUMMARY')?.value;
  String? get location => component.get('LOCATION')?.value;
  String? get description => component.get('DESCRIPTION')?.value;

  // Raw — typed conversion (TZID-aware) is the M3 calendar module's job.
  String? get dtstart => component.get('DTSTART')?.value;
  String? get dtend => component.get('DTEND')?.value;
  String? get rrule => component.get('RRULE')?.value;
  String? get organizer => component.get('ORGANIZER')?.value;

  // All ATTENDEE / EXDATE lines, preserved in document order.
  Iterable<String> get attendees =>
      component.getAll('ATTENDEE').map((p) => p.value);
  Iterable<String> get exdates =>
      component.getAll('EXDATE').map((p) => p.value);
  Iterable<String> get recurrenceIds =>
      component.getAll('RECURRENCE-ID').map((p) => p.value);

  // VALARMs as child components — each gets its own typed lens at M3.
  Iterable<IcalComponent> get alarms => component.childrenOf('VALARM');
}
