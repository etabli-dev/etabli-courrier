import 'package:meta/meta.dart';

import '../net/net_error.dart';

// Generic OAuth 2.0 authorization-code + PKCE surface. The M8 M365 backend
// runs against this — Gmail (v2) will reuse it unchanged. Real impl wraps
// flutter_appauth; tests run against a FakeOAuthProvider.
//
// Why an interface? Two reasons:
//   1. F-Droid hygiene — the provider lives in core/auth, but no M365-
//      specific identifier leaks in. Microsoft 365 is just one of multiple
//      possible OAuth providers; the Gmail seam (deferred to v2) plugs in
//      here without forking the protocol stack.
//   2. Testability — flutter_appauth opens a system browser, so it can't
//      run in `flutter test`. Every test against the M365 backend swaps in
//      a deterministic fake.

@immutable
class OAuthEndpoints {
  const OAuthEndpoints({
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
  });
  final String authorizationEndpoint;
  final String tokenEndpoint;
}

@immutable
class OAuthClientConfig {
  const OAuthClientConfig({
    required this.clientId,
    required this.redirectUri,
    required this.scopes,
    this.endpoints,
    this.issuer,
  });

  /// PUBLIC client ID — embedded in the binary is correct per Thunderbird/K-9
  /// posture. PKCE + redirect-URI registration provide the security, not
  /// secrecy of the ID.
  final String clientId;
  final String redirectUri;
  final List<String> scopes;

  /// Explicit endpoint URLs. Either this or [issuer] must be supplied.
  final OAuthEndpoints? endpoints;

  /// OIDC issuer URL. When supplied, flutter_appauth discovers the endpoints
  /// itself. Provider-specific examples live in the matching provider module
  /// — `core/auth` stays vendor-agnostic so the F-Droid isolation grep
  /// (`test/modules/mail/providers/microsoft365/isolation_test.dart`) holds.
  final String? issuer;
}

@immutable
class AuthBundle {
  const AuthBundle({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.idToken,
  });

  final String accessToken;
  final String? refreshToken;
  final DateTime expiresAt;
  final String? idToken;

  /// True when the access token will expire within [margin]. Tests use the
  /// default (1 minute) to drive the silent-refresh path.
  bool willExpireSoon({Duration margin = const Duration(minutes: 1)}) {
    return DateTime.now().add(margin).isAfter(expiresAt);
  }
}

abstract class OAuthProvider {
  /// Interactive login. Opens the system browser, returns the bundle.
  Future<AuthBundle> signIn(OAuthClientConfig config);

  /// Silent refresh using the refresh token. Throws an OAuthError when the
  /// refresh fails (so the caller can route to the right tenant-error UI).
  Future<AuthBundle> refresh({
    required OAuthClientConfig config,
    required String refreshToken,
  });

  /// Optional: revoke the refresh token on sign-out. Implementations that
  /// don't support revocation may simply return.
  Future<void> signOut({
    required OAuthClientConfig config,
    String? idTokenHint,
  }) async {}
}

@immutable
class OAuthError implements Exception {
  const OAuthError({required this.kind, required this.message, this.cause});

  /// 'consent_required' | 'invalid_grant' | 'invalid_request' |
  /// 'unauthorized_client' | 'access_denied' | 'unknown'
  final String kind;
  final String message;
  final Object? cause;

  /// Map this OAuth-specific failure into the cross-module NetError surface
  /// so the orchestrator can route via the existing M1 dispatch.
  NetError toNetError() {
    switch (kind) {
      case 'consent_required':
      case 'access_denied':
      case 'unauthorized_client':
      case 'invalid_grant':
        return UnauthorizedError(cause: cause);
      default:
        return UnknownNetError(cause: cause);
    }
  }

  @override
  String toString() => 'OAuthError($kind, $message)';
}
