import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';
import '../render/mime_render_plan.dart';

class MessageView extends StatelessWidget {
  MessageView({
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

  final DateFormat _dateFmt = DateFormat('MMM d · HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showRevealCard =
        plan.containedRemoteContent && !message.remoteContentAllowed;
    return ListView(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      children: [
        Text(
          message.subject ?? '(no subject)',
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: CourrierTokens.space2),
        Text(
          message.fromAddress ?? '(unknown sender)',
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          _dateFmt.format(message.receivedAt),
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: CourrierTokens.space5),
        if (showRevealCard) _RemoteContentCard(onReveal: onRevealRemoteContent),
        if (showRevealCard) const SizedBox(height: CourrierTokens.space4),
        if (plan.preferredText.isEmpty)
          Text('(empty body)', style: theme.textTheme.bodyMedium)
        else
          SelectableText(plan.preferredText, style: theme.textTheme.bodyMedium),
        if (plan.hasAttachments) ...[
          const SizedBox(height: CourrierTokens.space5),
          Text('Attachments', style: theme.textTheme.titleMedium),
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
                    _formatBytes(attachment.sizeBytes),
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
              TextButton(onPressed: onArchive, child: const Text('Archive')),
            const SizedBox(width: CourrierTokens.space2),
            if (onTrash != null)
              FilledButton.tonal(
                onPressed: onTrash,
                child: const Text('Move to trash'),
              ),
          ],
        ),
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
              'Remote content blocked. Showing local content only.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: CourrierTokens.space3),
          TextButton(onPressed: onReveal, child: const Text('Show images')),
        ],
      ),
    );
  }
}
