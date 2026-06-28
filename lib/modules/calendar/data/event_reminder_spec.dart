import 'package:meta/meta.dart';

// Plain in-memory shape for the editor / repo to pass reminders around without
// touching drift companions everywhere.

@immutable
class EventReminderSpec {
  const EventReminderSpec({
    this.minutesBeforeStart,
    this.absoluteTrigger,
    this.action = 'DISPLAY',
    this.label,
  });

  final int? minutesBeforeStart;
  final DateTime? absoluteTrigger;
  final String action;
  final String? label;
}
