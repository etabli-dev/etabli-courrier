import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/widgets/date_locale.dart';
import '../../../l10n/l10n.dart';
import '../render/mime_render_plan.dart';

class MessageView extends StatelessWidget {
  const MessageView({
    required this.message,
    required this.plan,
    this.onRevealRemoteContent,
    this.onArchive,
    this.onTrash,
    super.key,
  });

  final MailMessage message;
  final MimeRenderPlan plan;
  final VoidCallback? onRevealRemoteContent;
  final VoidCallback? onArchive;
  final VoidCallback? onTrash;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = l10n.dateLocale;
    final showRevealCard =
        plan.containedRemoteContent && !message.remoteContentAllowed;
    return ListView(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      children: [
        Text(
          message.subject ?? l10n.mailNoSubject,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: CourrierTokens.space2),
        Text(
          message.fromAddress ?? l10n.mailUnknownSender,
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          '${DateFormat.MMMd(locale).format(message.receivedAt)} · '
          '${DateFormat.Hm(locale).format(message.receivedAt)}',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: CourrierTokens.space5),
        if (showRevealCard) _RemoteContentCard(onReveal: onRevealRemoteContent),
        if (showRevealCard) const SizedBox(height: CourrierTokens.space4),
        if (plan.preferredText.isEmpty)
          Text(l10n.mailEmptyBody, style: theme.textTheme.bodyMedium)
        else
          SelectableText(plan.preferredText, style: theme.textTheme.bodyMedium),
        if (plan.hasAttachments) ...[
          const SizedBox(height: CourrierTokens.space5),
          Text(l10n.mailAttachments, style: theme.textTheme.titleMedium),
          const SizedBox(height: CourrierTokens.space2),
          for (final attachment in plan.attachments)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: CourrierTokens.space1,
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file_outlined, size: 16),
                  const SizedBox(width: CourrierTokens.space2),
                  Expanded(
                    child: Text(
                      attachment.filename,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    _formatBytes(attachment.sizeBytes, l10n.localeName),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: CourrierTokens.space6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onArchive != null)
              TextButton(onPressed: onArchive, child: Text(l10n.mailArchive)),
            const SizedBox(width: CourrierTokens.space2),
            if (onTrash != null)
              Tooltip(
                message: l10n.mailMoveToTrashTooltip,
                child: FilledButton.tonal(
                  onPressed: onTrash,
                  child: Text(l10n.mailMoveToTrash),
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formatBytes(int bytes, String locale) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final oneDecimal = NumberFormat('0.0', locale);
    if (bytes < 1024 * 1024) {
      return '${oneDecimal.format(bytes / 1024)} KB';
    }
    return '${oneDecimal.format(bytes / (1024 * 1024))} MB';
  }
}

class _RemoteContentCard extends StatelessWidget {
  const _RemoteContentCard({this.onReveal});

  final VoidCallback? onReveal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(CourrierTokens.space4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerTheme.color!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.mailRemoteContentBlocked,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: CourrierTokens.space3),
          if (onReveal != null)
            TextButton(
              onPressed: onReveal,
              child: Text(context.l10n.mailShowImages),
            ),
        ],
      ),
    );
  }
}
