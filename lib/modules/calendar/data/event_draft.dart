import 'package:meta/meta.dart';

import 'event_reminder_spec.dart';

// Editor-side payload — what the user composes before the repo turns it into
// a VEVENT + database rows. Pure data; no IO. ORGANIZER + ATTENDEE are stored
// as raw `mailto:` / `CN=…` strings so round-trip carries exactly what the
// server expects.

@immutable
class EventDraft {
  const EventDraft({
    required this.collectionId,
    required this.summary,
    required this.start,
    required this.end,
    this.uid,
    this.location,
    this.description,
    this.allDay = false,
    this.rrule,
    this.organizer,
    this.attendees = const <String>[],
    this.reminders = const <EventReminderSpec>[],
    this.exdates = const <String>[],
  });

  final int collectionId;
  final String? uid;
  final String summary;
  final DateTime start;
  final DateTime end;
  final String? location;
  final String? description;
  final bool allDay;
  final String? rrule;
  final String? organizer;
  final List<String> attendees;
  final List<EventReminderSpec> reminders;
  final List<String> exdates;

  EventDraft copyWith({
    String? summary,
    DateTime? start,
    DateTime? end,
    String? location,
    String? description,
    bool? allDay,
    String? rrule,
    String? organizer,
    List<String>? attendees,
    List<EventReminderSpec>? reminders,
    List<String>? exdates,
  }) => EventDraft(
    collectionId: collectionId,
    uid: uid,
    summary: summary ?? this.summary,
    start: start ?? this.start,
    end: end ?? this.end,
    location: location ?? this.location,
    description: description ?? this.description,
    allDay: allDay ?? this.allDay,
    rrule: rrule ?? this.rrule,
    organizer: organizer ?? this.organizer,
    attendees: attendees ?? this.attendees,
    reminders: reminders ?? this.reminders,
    exdates: exdates ?? this.exdates,
  );
}
