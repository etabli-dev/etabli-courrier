import 'package:meta/meta.dart';

// Sealed credentials surface. M6 ships PasswordCredentials (plain IMAP/SMTP
// password) and an OAuth bearer variant the M8 Microsoft 365 provider plugs
// into. The MailBackend interface accepts either — no protocol fork.

@immutable
sealed class MailCredentials {
  const MailCredentials({required this.username});
  final String username;
}

@immutable
class PasswordCredentials extends MailCredentials {
  const PasswordCredentials({required super.username, required this.password});
  final String password;
}

@immutable
class XoauthBearerCredentials extends MailCredentials {
  const XoauthBearerCredentials({
    required super.username,
    required this.accessToken,
    this.tokenExpiresAt,
  });

  final String accessToken;

  /// When `null` the backend will not refresh proactively; M8 wires the
  /// refresh path through `core/auth` and supplies a fresh token before
  /// `connect()` is called.
  final DateTime? tokenExpiresAt;
}
