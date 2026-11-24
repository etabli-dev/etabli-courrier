import 'package:flutter/material.dart';

import '../core/db/database.dart';
import '../core/lock/app_security.dart';
import '../core/platform/platform_capabilities.dart';
import '../core/sync/account_services.dart';
import '../l10n/l10n.dart';
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
import '../modules/reminders/scheduler/reminder_coordinator.dart';
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

  /// The module's name in the app's current language.
  final String Function(AppLocalizations l10n) label;
  final IconData icon;
  final WidgetBuilder builder;
}

List<ModuleDestination> moduleDestinations(
  CourrierDatabase db, {
  AccountServices? services,
  ReminderCoordinator? reminders,
}) => [
  ModuleDestination(
    label: (l) => l.navMail,
    icon: Icons.mail_outline,
    builder: (_) =>
        MailScreen(db: db, downloadMessage: services?.downloadMessage),
  ),
  ModuleDestination(
    label: (l) => l.navCalendar,
    icon: Icons.calendar_today_outlined,
    builder: (_) => CalendarScreen(repository: CalendarRepository(db: db)),
  ),
  ModuleDestination(
    label: (l) => l.navContacts,
    icon: Icons.person_outline,
    builder: (_) => ContactsScreen(repository: ContactRepository(db: db)),
  ),
  ModuleDestination(
    label: (l) => l.navTasks,
    icon: Icons.check_box_outlined,
    builder: (_) => TasksScreen(repository: TaskRepository(db: db)),
  ),
  ModuleDestination(
    label: (l) => l.navReminders,
    icon: Icons.alarm,
    builder: (_) {
      final scheduler = reminders?.scheduler ?? LocalNotificationScheduler();
      return RemindersScreen(
        scheduler: scheduler,
        refreshSchedule: reminders?.refresh,
        rearmService:
            reminders?.service ??
            ReminderRearmService(db: db, scheduler: scheduler),
        unavailableReason: PlatformCapabilities.scheduledReminders
            ? null
            : L10n.current.shellRemindersUnavailable(
                PlatformCapabilities.inBuildName,
              ),
      );
    },
  ),
  ModuleDestination(
    label: (l) => l.navNotes,
    icon: Icons.notes,
    builder: (_) => NotesScreen(
      repository: NoteRepository(db: db),
      unlock: services == null || !PlatformCapabilities.deviceAuthentication
          ? null
          : AppSecurity.unlock,
    ),
  ),
  ModuleDestination(
    label: (l) => l.navFeeds,
    icon: Icons.rss_feed,
    builder: (_) => FeedsScreen(db: db),
  ),
];
