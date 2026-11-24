import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/tokens.dart';
import '../../../core/widgets/date_locale.dart';
import '../../../l10n/l10n.dart';
import '../data/mail_repository.dart';

class ThreadListView extends StatelessWidget {
  const ThreadListView({required this.threads, this.onThreadTap, super.key});

  final List<MailThread> threads;
  final ValueChanged<MailThread>? onThreadTap;

  @override
  Widget build(BuildContext context) {
    if (threads.isEmpty) {
      return const _Empty();
    }
    final date = DateFormat.MMMd(context.l10n.dateLocale);
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space3,
      ),
      itemCount: threads.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space4),
      itemBuilder: (context, i) {
        final thread = threads[i];
        return _ThreadTile(
          thread: thread,
          dateLabel: date.format(thread.lastReceivedAt),
          onTap: onThreadTap == null ? null : () => onThreadTap!(thread),
        );
      },
    );
  }
}

class _ThreadTile extends StatelessWidget {
  const _ThreadTile({
    required this.thread,
    required this.dateLabel,
    this.onTap,
  });

  final MailThread thread;
  final String dateLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final latest = thread.latest;
    final unread = !latest.seen;
    final count = thread.messages.length;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CourrierTokens.space2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (unread)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(
                  top: 6,
                  right: CourrierTokens.space2,
                ),
                color: Theme.of(context).colorScheme.primary,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          latest.fromAddress ?? l10n.mailUnknownSender,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (count > 1)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: CourrierTokens.space2,
                          ),
                          child: Text(
                            '$count',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      Text(dateLabel, style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: CourrierTokens.space1),
                  Text(
                    latest.subject ?? l10n.mailNoSubject,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (latest.snippet != null) ...[
                    const SizedBox(height: CourrierTokens.space1),
                    Text(
                      latest.snippet!,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
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
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space6),
        child: Text(
          context.l10n.mailNoMessages,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
