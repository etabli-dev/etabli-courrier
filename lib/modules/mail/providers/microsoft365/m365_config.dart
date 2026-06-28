import 'package:meta/meta.dart';

import '../../../../core/auth/oauth_provider.dart';

// Microsoft 365 / Exchange Online configuration. Values are the PREFLIGHT
// locked decisions for the v1 mail-only OAuth provider — change them in
// PREFLIGHT.md, not here.
//
// F-DROID HYGIENE: this file is the only place outside of test fixtures that
// names `login.microsoftonline.com` / `outlook.office365.com` /
// `outlook.office.com`. The license-gate.yml advisory grep walks the tree
// to catch leakage; M11 promotes the advisory into a hard fail.

@immutable
class M365Config {
  const M365Config({
    required this.clientId,
    this.tenant = 'common',
    this.redirectUri = 'dev.etabli.courrier://oauth',
    this.imapHost = 'outlook.office365.com',
    this.imapPort = 993,
    this.smtpHost = 'smtp.office365.com',
    this.smtpPort = 587,
  });

  final String clientId;

  /// `common` (default), `organizations`, `consumers`, or a tenant GUID.
  final String tenant;
  final String redirectUri;

  final String imapHost;
  final int imapPort;
  final String smtpHost;
  final int smtpPort;

  /// PREFLIGHT-locked scopes:
  ///   * `offline_access`                                  — refresh tokens
  ///   * `https://outlook.office.com/IMAP.AccessAsUser.All` — IMAP XOAUTH2
  ///   * `https://outlook.office.com/SMTP.Send`             — SMTP XOAUTH2
  List<String> get scopes => const [
    'offline_access',
    'https://outlook.office.com/IMAP.AccessAsUser.All',
    'https://outlook.office.com/SMTP.Send',
  ];

  String get authority => 'https://login.microsoftonline.com/$tenant';

  OAuthClientConfig toClientConfig() {
    return OAuthClientConfig(
      clientId: clientId,
      redirectUri: redirectUri,
      scopes: scopes,
      issuer: '$authority/v2.0',
      endpoints: OAuthEndpoints(
        authorizationEndpoint: '$authority/oauth2/v2.0/authorize',
        tokenEndpoint: '$authority/oauth2/v2.0/token',
      ),
    );
  }
}
