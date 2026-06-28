import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/tokens.dart';
import '../scheduler/notification_scheduler.dart';

class RemindersListView extends StatelessWidget {
  RemindersListView({
    required this.reminders,
    required this.hasPermission,
    this.onRequestPermission,
    this.onReload,
    super.key,
  });

  final List<ScheduledNotification> reminders;
  final bool hasPermission;
  final VoidCallback? onRequestPermission;
  final VoidCallback? onReload;

  final DateFormat _whenFmt = DateFormat('MMM d, HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space4,
      ),
      children: [
        if (!hasPermission) _PermissionCard(onRequest: onRequestPermission),
        if (!hasPermission) const SizedBox(height: CourrierTokens.space4),
        Row(
          children: [
            Text('Upcoming reminders', style: theme.textTheme.titleMedium),
            const Spacer(),
            if (onReload != null)
              TextButton(onPressed: onReload, child: const Text('Reload')),
          ],
        ),
        const SizedBox(height: CourrierTokens.space2),
        if (reminders.isEmpty)
          Text('Nothing scheduled.', style: theme.textTheme.bodyMedium)
        else
          for (final reminder in reminders)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: CourrierTokens.space2,
              ),
              child: _ReminderTile(
                reminder: reminder,
                whenLabel: _whenFmt.format(reminder.fireAt),
              ),
            ),
      ],
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({this.onRequest});

  final VoidCallback? onRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(CourrierTokens.space4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerTheme.color!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notification permission required',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: CourrierTokens.space2),
          Text(
            'courrier needs permission to send reminders for calendar events'
            ' and tasks.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: CourrierTokens.space3),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onRequest,
              child: const Text('Allow notifications'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.whenLabel});

  final ScheduledNotification reminder;
  final String whenLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 28,
          margin: const EdgeInsets.only(top: 4, right: CourrierTokens.space3),
          color: CourrierTokens.accent,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reminder.title, style: theme.textTheme.bodyLarge),
              const SizedBox(height: CourrierTokens.space1),
              Text(whenLabel, style: theme.textTheme.bodySmall),
              if (reminder.body.isNotEmpty)
                Text(reminder.body, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        if (reminder.isRecurring)
          Padding(
            padding: const EdgeInsets.only(left: CourrierTokens.space2),
            child: Text('weekly', style: theme.textTheme.bodySmall),
          ),
      ],
    );
  }
}
