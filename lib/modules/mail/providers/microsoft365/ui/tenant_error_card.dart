import 'package:flutter/material.dart';

import '../../../../../core/theme/tokens.dart';
import '../../../../../l10n/l10n.dart';
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
    final l10n = context.l10n;
    final descriptor = _describe(state, l10n);
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
                Tooltip(
                  message: l10n.m365OpenAdminDocsTooltip,
                  child: TextButton(
                    onPressed: onOpenAdminDocs,
                    child: Text(descriptor.adminDocsCta!),
                  ),
                ),
              const Spacer(),
              if (onRetry != null)
                FilledButton(
                  onPressed: onRetry,
                  child: Text(l10n.m365TryAgain),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _TenantErrorDescriptor? _describe(TenantState state, AppLocalizations l10n) {
    switch (state) {
      case TenantConnected():
        return null;
      case AdminConsentRequired(:final detail):
        return _TenantErrorDescriptor(
          title: l10n.m365ConsentTitle,
          body: l10n.m365ConsentBody,
          detail: detail,
          adminDocsCta: l10n.m365OpenAdminDocs,
        );
      case AppBlockedByTenantPolicy(:final detail):
        return _TenantErrorDescriptor(
          title: l10n.m365BlockedTitle,
          body: l10n.m365BlockedBody,
          detail: detail,
          adminDocsCta: l10n.m365OpenAdminDocs,
        );
      case ImapDisabledByAdmin(:final detail):
        return _TenantErrorDescriptor(
          title: l10n.m365ImapDisabledTitle,
          body: l10n.m365ImapDisabledBody,
          detail: detail,
          adminDocsCta: l10n.m365OpenAdminDocs,
        );
      case SmtpAuthDisabledForMailbox(:final detail):
        return _TenantErrorDescriptor(
          title: l10n.m365SmtpDisabledTitle,
          body: l10n.m365SmtpDisabledBody,
          detail: detail,
          adminDocsCta: l10n.m365OpenAdminDocs,
        );
      case TenantAuthFailedGeneric(:final detail):
        return _TenantErrorDescriptor(
          title: l10n.m365FailedTitle,
          body: l10n.m365FailedBody,
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
