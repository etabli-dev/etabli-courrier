import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/recurrence/rrule_formatter.dart';
import '../../../core/theme/tokens.dart';

class AgendaView extends StatelessWidget {
  AgendaView({required this.events, this.onEventTap, super.key});

  final List<CalendarEvent> events;
  final ValueChanged<CalendarEvent>? onEventTap;

  final RruleFormatter _rrule = RruleFormatter();
  final DateFormat _date = DateFormat.MMMEd();
  final DateFormat _time = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return _Empty();
    }
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
          rruleText: event.rrule == null ? null : _rrule.format(event.rrule!),
          dateLabel: event.allDay
              ? _date.format(event.dtstart!)
              : '${_date.format(event.dtstart!)} · ${_time.format(event.dtstart!)}',
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
              color: CourrierTokens.accent,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.summary ?? '(no title)',
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
          'No events in this range.',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
