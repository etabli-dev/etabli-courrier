// Two-tier configuration seam. See PREFLIGHT.md §4.
//
//   * The M365 client ID is PUBLIC and may be embedded here.
//   * Test credentials (passwords, app-passwords) live ONLY in secrets.json
//     (gitignored) and reach the binary via `--dart-define-from-file=secrets.json`.
//   * OAuth refresh tokens land in flutter_secure_storage at M1 — never in this file.

import 'package:flutter/foundation.dart';

@immutable
class RuntimeConfig {
  const RuntimeConfig._();

  // ---- Nextcloud (consumed from M2 onward) -----------------------------------------------
  static const String nextcloudBaseUrl = String.fromEnvironment(
    'NEXTCLOUD_BASE_URL',
  );
  static const String nextcloudUser = String.fromEnvironment('NEXTCLOUD_USER');
  static const String nextcloudAppPassword = String.fromEnvironment(
    'NEXTCLOUD_APP_PASSWORD',
  );

  // ---- IMAP / SMTP (consumed from M6 onward) ---------------------------------------------
  static const String imapHost = String.fromEnvironment('IMAP_HOST');
  static const String imapPort = String.fromEnvironment(
    'IMAP_PORT',
    defaultValue: '993',
  );
  static const String imapUser = String.fromEnvironment('IMAP_USER');
  static const String imapPassword = String.fromEnvironment('IMAP_PASSWORD');

  static const String smtpHost = String.fromEnvironment('SMTP_HOST');
  static const String smtpPort = String.fromEnvironment(
    'SMTP_PORT',
    defaultValue: '587',
  );
  static const String smtpUser = String.fromEnvironment('SMTP_USER');
  static const String smtpPassword = String.fromEnvironment('SMTP_PASSWORD');

  // ---- Microsoft 365 OAuth (consumed at M8) ----------------------------------------------
  // The client ID is public — same posture as Thunderbird/K-9. PKCE + redirect URI
  // restriction provide the security, not ID secrecy.
  static const String m365ClientId = String.fromEnvironment('M365_CLIENT_ID');
  static const String m365Tenant = String.fromEnvironment(
    'M365_TENANT',
    defaultValue: 'common',
  );
  static const String m365RedirectScheme = String.fromEnvironment(
    'M365_REDIRECT_SCHEME',
    defaultValue: 'dev.etabli.courrier',
  );
  static const String m365RedirectUri = String.fromEnvironment(
    'M365_REDIRECT_URI',
    defaultValue: 'dev.etabli.courrier://oauth',
  );

  static bool get hasNextcloudCredentials =>
      nextcloudBaseUrl.isNotEmpty &&
      nextcloudUser.isNotEmpty &&
      nextcloudAppPassword.isNotEmpty;

  static bool get hasImapCredentials =>
      imapHost.isNotEmpty && imapUser.isNotEmpty && imapPassword.isNotEmpty;

  static bool get hasM365ClientId => m365ClientId.isNotEmpty;
}
