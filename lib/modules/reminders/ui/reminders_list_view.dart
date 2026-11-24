import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/date_locale.dart';
import '../../../l10n/l10n.dart';
import '../scheduler/notification_scheduler.dart';

class RemindersListView extends StatelessWidget {
  const RemindersListView({
    required this.reminders,
    required this.hasPermission,
    this.onRequestPermission,
    this.onReload,
    this.unavailableReason,
    this.scheduleLimit,
    super.key,
  });

  final List<ScheduledNotification> reminders;
  final bool hasPermission;
  final int? scheduleLimit;
  final VoidCallback? onRequestPermission;
  final VoidCallback? onReload;

  /// Replaces the permission card when this platform cannot deliver
  /// reminder notifications.
  final String? unavailableReason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final day = DateFormat.MMMd(l10n.dateLocale);
    final time = DateFormat.Hm(l10n.dateLocale);
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space4,
      ),
      children: [
        if (unavailableReason != null)
          _UnavailableCard(reason: unavailableReason!)
        else if (!hasPermission)
          _PermissionCard(onRequest: onRequestPermission),
        if (unavailableReason != null || !hasPermission)
          const SizedBox(height: CourrierTokens.space4),
        Row(
          children: [
            Text(l10n.remindersUpcoming, style: theme.textTheme.titleMedium),
            const Spacer(),
            if (onReload != null)
              TextButton(
                onPressed: onReload,
                child: Text(l10n.remindersReload),
              ),
          ],
        ),
        const SizedBox(height: CourrierTokens.space2),
        if (scheduleLimit != null && reminders.length > scheduleLimit!)
          Text(l10n.remindersScheduleLimit(scheduleLimit!)),
        if (reminders.isEmpty)
          Text(
            l10n.remindersNothingScheduled,
            style: theme.textTheme.bodyMedium,
          )
        else
          for (final reminder in reminders)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: CourrierTokens.space2,
              ),
              child: _ReminderTile(
                reminder: reminder,
                whenLabel:
                    '${day.format(reminder.fireAt)}, ${time.format(reminder.fireAt)}',
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
            context.l10n.remindersPermissionTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: CourrierTokens.space2),
          Text(
            context.l10n.remindersPermissionBody,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: CourrierTokens.space3),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: onRequest,
              child: Text(context.l10n.remindersAllowNotifications),
            ),
          ),
        ],
      ),
    );
  }
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard({required this.reason});

  final String reason;

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
            context.l10n.remindersUnavailableTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: CourrierTokens.space2),
          Text(reason, style: theme.textTheme.bodyMedium),
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
          color: Theme.of(context).colorScheme.primary,
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
            child: Text(
              context.l10n.remindersWeekly,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
