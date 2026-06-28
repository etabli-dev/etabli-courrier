import 'package:meta/meta.dart';

import '../../../../core/auth/oauth_provider.dart';
import '../../../../core/net/net_error.dart';

// Tenant-friction is first-class UX (BUILD_PROMPT M8): every recoverable
// failure shows the user an actionable card instead of crashing silently.
// `TenantStateClassifier` maps an OAuth/IMAP/SMTP error into one of these
// states; the UI in `ui/tenant_error_card.dart` renders a tailored message
// + CTA per state.

@immutable
sealed class TenantState {
  const TenantState();
}

class TenantConnected extends TenantState {
  const TenantConnected();
}

class AdminConsentRequired extends TenantState {
  const AdminConsentRequired({this.detail});
  final String? detail;
}

class AppBlockedByTenantPolicy extends TenantState {
  const AppBlockedByTenantPolicy({this.detail});
  final String? detail;
}

class ImapDisabledByAdmin extends TenantState {
  const ImapDisabledByAdmin({this.detail});
  final String? detail;
}

class SmtpAuthDisabledForMailbox extends TenantState {
  const SmtpAuthDisabledForMailbox({this.detail});
  final String? detail;
}

class TenantAuthFailedGeneric extends TenantState {
  const TenantAuthFailedGeneric({this.detail});
  final String? detail;
}

class TenantStateClassifier {
  const TenantStateClassifier();

  TenantState classifyOAuthError(OAuthError error) {
    switch (error.kind) {
      case 'consent_required':
        return AdminConsentRequired(detail: error.message);
      case 'access_denied':
      case 'unauthorized_client':
        return AppBlockedByTenantPolicy(detail: error.message);
      default:
        return TenantAuthFailedGeneric(detail: error.message);
    }
  }

  /// IMAP / SMTP responses surface as NetError plus a short server line. We
  /// look for the signal words Microsoft documents in their tenant-policy
  /// pages (and Exchange Online surface) — see BUILD_PROMPT M8 watch list.
  TenantState classifyMailError(NetError error, {String? serverLine}) {
    final hint = (serverLine ?? '').toLowerCase();
    if (hint.contains('imap is disabled') ||
        hint.contains('mailbox cannot login') ||
        hint.contains('logindisabled')) {
      return ImapDisabledByAdmin(detail: serverLine);
    }
    if (hint.contains('smtp auth has been disabled') ||
        hint.contains('5.7.139') ||
        hint.contains('smtpsendisenabled is false')) {
      return SmtpAuthDisabledForMailbox(detail: serverLine);
    }
    if (error is UnauthorizedError) {
      return const TenantAuthFailedGeneric();
    }
    return TenantAuthFailedGeneric(detail: serverLine);
  }
}
