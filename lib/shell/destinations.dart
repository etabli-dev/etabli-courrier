import 'package:flutter/material.dart';

import '../core/db/database.dart';
import '../core/lock/app_security.dart';
import '../core/sync/account_services.dart';
import '../modules/calendar/calendar_screen.dart';
import '../modules/calendar/data/calendar_repository.dart';
import '../modules/contacts/contacts_screen.dart';
import '../modules/contacts/data/contact_repository.dart';
import '../modules/feeds/feeds_screen.dart';
import '../modules/mail/mail_screen.dart';
import '../modules/notes/data/note_repository.dart';
import '../modules/notes/notes_screen.dart';
import '../modules/reminders/reminders_screen.dart';
import '../modules/reminders/scheduler/local_notification_scheduler.dart';
import '../modules/reminders/scheduler/reminder_rearm_service.dart';
import '../modules/tasks/data/task_repository.dart';
import '../modules/tasks/tasks_screen.dart';

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

List<ModuleDestination> moduleDestinations(
  CourrierDatabase db, {
  AccountServices? services,
}) => [
  ModuleDestination(
    label: 'mail',
    icon: Icons.mail_outline,
    builder: (_) =>
        MailScreen(db: db, downloadMessage: services?.downloadMessage),
  ),
  ModuleDestination(
    label: 'calendar',
    icon: Icons.calendar_today_outlined,
    builder: (_) => CalendarScreen(repository: CalendarRepository(db: db)),
  ),
  ModuleDestination(
    label: 'contacts',
    icon: Icons.person_outline,
    builder: (_) => ContactsScreen(repository: ContactRepository(db: db)),
  ),
  ModuleDestination(
    label: 'tasks',
    icon: Icons.check_box_outlined,
    builder: (_) => TasksScreen(repository: TaskRepository(db: db)),
  ),
  ModuleDestination(
    label: 'reminders',
    icon: Icons.alarm,
    builder: (_) {
      final scheduler = LocalNotificationScheduler();
      return RemindersScreen(
        scheduler: scheduler,
        rearmService: ReminderRearmService(db: db, scheduler: scheduler),
      );
    },
  ),
  ModuleDestination(
    label: 'notes',
    icon: Icons.notes,
    builder: (_) => NotesScreen(
      repository: NoteRepository(db: db),
      unlock: services == null ? null : AppSecurity.unlock,
    ),
  ),
  ModuleDestination(
    label: 'feeds',
    icon: Icons.rss_feed,
    builder: (_) => FeedsScreen(db: db),
  ),
];
