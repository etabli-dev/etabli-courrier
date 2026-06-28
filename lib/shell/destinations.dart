import 'package:flutter/material.dart';

import '../modules/mail/mail_screen.dart';
import 'module_placeholder.dart';

@immutable
class ModuleDestination {
  const ModuleDestination({
    required this.label,
    required this.icon,
    required this.builder,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;
}

const List<ModuleDestination> kModuleDestinations = [
  ModuleDestination(
    label: 'mail',
    icon: Icons.mail_outline,
    builder: _buildMail,
  ),
  ModuleDestination(
    label: 'calendar',
    icon: Icons.calendar_today_outlined,
    builder: _buildCalendar,
  ),
  ModuleDestination(
    label: 'contacts',
    icon: Icons.person_outline,
    builder: _buildContacts,
  ),
  ModuleDestination(
    label: 'tasks',
    icon: Icons.check_box_outlined,
    builder: _buildTasks,
  ),
  ModuleDestination(
    label: 'reminders',
    icon: Icons.alarm,
    builder: _buildReminders,
  ),
  ModuleDestination(label: 'notes', icon: Icons.notes, builder: _buildNotes),
  ModuleDestination(label: 'feeds', icon: Icons.rss_feed, builder: _buildFeeds),
];

Widget _buildMail(BuildContext _) => const MailScreen();

// The wired CalendarScreen requires a CalendarRepository; the shell wires it
// at M11 once the account orchestrator boots. Until then, render the
// placeholder so the global navigation stays functional. Direct instances of
// CalendarScreen (with a repo) work from M3 tests and the M14 sample-content
// route.
Widget _buildCalendar(BuildContext _) => const ModulePlaceholder(
  title: 'calendar',
  synopsis:
      'CalDAV VEVENT (M3 built; shell wiring at M11). Agenda + month'
      ' views, RRULE parse + human-readable formatting, multiple reminders,'
      ' all-day + DST, recurrence delete (this/this-and-following/all).',
);

// The wired ContactsScreen requires a ContactRepository; the shell wires it
// at M11 once the account orchestrator boots. Until then, render the
// placeholder so the global navigation stays functional. Direct instances of
// ContactsScreen (with a repo) work from M4 tests.
Widget _buildContacts(BuildContext _) => const ModulePlaceholder(
  title: 'contacts',
  synopsis:
      'CardDAV vCard (M4 built; shell wiring at M11). List/detail/CRUD,'
      ' photos, groups, unknown-property preservation on round-trip.',
);
// The wired TasksScreen requires a TaskRepository; the shell wires it at M11.
// Direct instances of TasksScreen (with a repo) work from M5 tests.
Widget _buildTasks(BuildContext _) => const ModulePlaceholder(
  title: 'tasks',
  synopsis:
      'VTODO (M5 built; shell wiring at M11). Subtasks via'
      ' RELATED-TO;RELTYPE=PARENT, fixed RRULE + repeat-after-completion,'
      ' alarms via flutter_local_notifications, re-arm on reboot/launch.',
);
// The wired RemindersScreen requires a NotificationScheduler + ReminderRearmService;
// the shell wires them at M11. Direct instances work from M5 tests.
Widget _buildReminders(BuildContext _) => const ModulePlaceholder(
  title: 'reminders',
  synopsis:
      'flutter_local_notifications from VALARM + due dates (M5 built;'
      ' shell wiring at M11). Re-arm on reboot (Android) / on launch (iOS).',
);
// NotesScreen requires a NoteRepository; shell wires it at M11. Direct
// instances of NotesScreen work from M9 tests.
Widget _buildNotes(BuildContext _) => const ModulePlaceholder(
  title: 'notes',
  synopsis:
      'Nextcloud Notes REST (M9 built; shell wiring at M11). Text + checklist,'
      ' editor undo/redo, optional per-note lock, 1:1 note-file round-trip.',
);
// FeedsScreen surface requires a FeedRepository + sync backend; the shell
// wires them at M11. The direct UI widgets work from M10 tests.
Widget _buildFeeds(BuildContext _) => const ModulePlaceholder(
  title: 'feeds',
  synopsis:
      'Nextcloud News API + bundled standalone parser fallback (M10 built;'
      ' shell wiring at M11). Offline reading, shared CustomIntervalPicker'
      ' for refresh.',
);
