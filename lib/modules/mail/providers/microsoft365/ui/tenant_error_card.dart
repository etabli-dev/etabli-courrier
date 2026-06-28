import 'package:flutter/material.dart';

import '../../../../../core/theme/tokens.dart';
import '../tenant_state.dart';

class TenantErrorCard extends StatelessWidget {
  const TenantErrorCard({
    required this.state,
    this.onRetry,
    this.onOpenAdminDocs,
    super.key,
  });

  final TenantState state;
  final VoidCallback? onRetry;
  final VoidCallback? onOpenAdminDocs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final descriptor = _describe(state);
    if (descriptor == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(CourrierTokens.space4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerTheme.color!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(descriptor.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: CourrierTokens.space2),
          Text(descriptor.body, style: theme.textTheme.bodyMedium),
          if (descriptor.detail != null) ...[
            const SizedBox(height: CourrierTokens.space2),
            Text(descriptor.detail!, style: theme.textTheme.bodySmall),
          ],
          const SizedBox(height: CourrierTokens.space3),
          Row(
            children: [
              if (descriptor.adminDocsCta != null && onOpenAdminDocs != null)
                TextButton(
                  onPressed: onOpenAdminDocs,
                  child: Text(descriptor.adminDocsCta!),
                ),
              const Spacer(),
              if (onRetry != null)
                FilledButton(
                  onPressed: onRetry,
                  child: const Text('Try again'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _TenantErrorDescriptor? _describe(TenantState state) {
    switch (state) {
      case TenantConnected():
        return null;
      case AdminConsentRequired(:final detail):
        return _TenantErrorDescriptor(
          title: 'Admin consent required',
          body:
              'Your IT administrator needs to grant courrier access for your '
              'tenant. Share the documentation link with them, then try again.',
          detail: detail,
          adminDocsCta: 'Open admin docs',
        );
      case AppBlockedByTenantPolicy(:final detail):
        return _TenantErrorDescriptor(
          title: 'App blocked by tenant policy',
          body:
              'Your tenant blocks third-party mail apps. Ask your admin to '
              'allow courrier, then try again.',
          detail: detail,
          adminDocsCta: 'Open admin docs',
        );
      case ImapDisabledByAdmin(:final detail):
        return _TenantErrorDescriptor(
          title: 'IMAP disabled by your admin',
          body:
              'IMAP is turned off on this tenant. Your admin needs to enable '
              'IMAP access for your mailbox before courrier can sync mail.',
          detail: detail,
          adminDocsCta: 'Open admin docs',
        );
      case SmtpAuthDisabledForMailbox(:final detail):
        return _TenantErrorDescriptor(
          title: 'SMTP AUTH disabled for this mailbox',
          body:
              'Modern tenants disable SMTP AUTH per-mailbox by default. Your '
              'admin needs to enable SMTP AUTH on your mailbox to send mail.',
          detail: detail,
          adminDocsCta: 'Open admin docs',
        );
      case TenantAuthFailedGeneric(:final detail):
        return _TenantErrorDescriptor(
          title: 'Connection failed',
          body: 'courrier could not sign in to Microsoft 365.',
          detail: detail,
        );
    }
  }
}

class _TenantErrorDescriptor {
  const _TenantErrorDescriptor({
    required this.title,
    required this.body,
    this.detail,
    this.adminDocsCta,
  });
  final String title;
  final String body;
  final String? detail;
  final String? adminDocsCta;
}
