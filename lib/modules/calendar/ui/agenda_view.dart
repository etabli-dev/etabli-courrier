import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/recurrence/rrule_formatter.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/date_locale.dart';
import '../../../l10n/l10n.dart';

class AgendaView extends StatelessWidget {
  const AgendaView({required this.events, this.onEventTap, super.key});

  final List<CalendarEvent> events;
  final ValueChanged<CalendarEvent>? onEventTap;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _Empty();
    }
    final l10n = context.l10n;
    final rrule = RruleFormatter(l10n: l10n);
    final date = DateFormat.MMMEd(l10n.dateLocale);
    final time = DateFormat.Hm(l10n.dateLocale);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space4,
      ),
      itemCount: events.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space5),
      itemBuilder: (context, i) {
        final event = events[i];
        return _AgendaTile(
          event: event,
          rruleText: event.rrule == null ? null : rrule.format(event.rrule!),
          dateLabel: event.allDay
              ? date.format(event.dtstart!)
              : '${date.format(event.dtstart!)} · ${time.format(event.dtstart!)}',
          onTap: onEventTap == null ? null : () => onEventTap!(event),
        );
      },
    );
  }
}

class _AgendaTile extends StatelessWidget {
  const _AgendaTile({
    required this.event,
    required this.dateLabel,
    this.rruleText,
    this.onTap,
  });

  final CalendarEvent event;
  final String dateLabel;
  final String? rruleText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CourrierTokens.space2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              height: 36,
              margin: const EdgeInsets.only(
                top: 4,
                right: CourrierTokens.space3,
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.summary ?? context.l10n.calendarNoTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: CourrierTokens.space1),
                  Text(dateLabel, style: theme.textTheme.bodyMedium),
                  if (rruleText != null) ...[
                    const SizedBox(height: CourrierTokens.space1),
                    Text(rruleText!, style: theme.textTheme.bodySmall),
                  ],
                  if (event.location != null && event.location!.isNotEmpty) ...[
                    const SizedBox(height: CourrierTokens.space1),
                    Text(event.location!, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space6),
        child: Text(
          context.l10n.calendarNoEvents,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
