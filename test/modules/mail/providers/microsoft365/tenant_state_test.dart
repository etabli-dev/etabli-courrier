import 'package:courrier/core/auth/oauth_provider.dart';
import 'package:courrier/core/net/net_error.dart';
import 'package:courrier/modules/mail/providers/microsoft365/tenant_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const classifier = TenantStateClassifier();

  group('classifyOAuthError', () {
    test('consent_required → AdminConsentRequired', () {
      final state = classifier.classifyOAuthError(
        const OAuthError(
          kind: 'consent_required',
          message: 'AADSTS65001: admin consent required',
        ),
      );
      expect(state, isA<AdminConsentRequired>());
    });

    test('access_denied → AppBlockedByTenantPolicy', () {
      final state = classifier.classifyOAuthError(
        const OAuthError(
          kind: 'access_denied',
          message: 'AADSTS50105: tenant policy blocks the app',
        ),
      );
      expect(state, isA<AppBlockedByTenantPolicy>());
    });

    test('unauthorized_client → AppBlockedByTenantPolicy', () {
      final state = classifier.classifyOAuthError(
        const OAuthError(
          kind: 'unauthorized_client',
          message: 'AADSTS50020: unauthorized client',
        ),
      );
      expect(state, isA<AppBlockedByTenantPolicy>());
    });

    test('unknown → TenantAuthFailedGeneric', () {
      final state = classifier.classifyOAuthError(
        const OAuthError(kind: 'unknown', message: 'something'),
      );
      expect(state, isA<TenantAuthFailedGeneric>());
    });
  });

  group('classifyMailError', () {
    test('IMAP disabled by admin server line → ImapDisabledByAdmin', () {
      final state = classifier.classifyMailError(
        const UnauthorizedError(),
        serverLine: 'NO LOGINDISABLED IMAP is disabled for this tenant',
      );
      expect(state, isA<ImapDisabledByAdmin>());
    });

    test('SMTP AUTH disabled (5.7.139) → SmtpAuthDisabledForMailbox', () {
      final state = classifier.classifyMailError(
        const UnauthorizedError(),
        serverLine: '535 5.7.139 SMTP AUTH has been disabled.',
      );
      expect(state, isA<SmtpAuthDisabledForMailbox>());
    });

    test('Generic UnauthorizedError → TenantAuthFailedGeneric', () {
      final state = classifier.classifyMailError(const UnauthorizedError());
      expect(state, isA<TenantAuthFailedGeneric>());
    });
  });
}
