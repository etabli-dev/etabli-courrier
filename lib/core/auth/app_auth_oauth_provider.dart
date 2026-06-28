import 'package:flutter_appauth/flutter_appauth.dart';

import 'oauth_provider.dart';

// flutter_appauth-backed OAuthProvider. NEVER used in `flutter test` — the
// browser handoff makes it untestable without a real device session. Tests
// run against a FakeOAuthProvider (see test/core/auth/).

class AppAuthOAuthProvider implements OAuthProvider {
  AppAuthOAuthProvider({FlutterAppAuth? appAuth})
    : _appAuth = appAuth ?? const FlutterAppAuth();

  final FlutterAppAuth _appAuth;

  @override
  Future<AuthBundle> signIn(OAuthClientConfig config) async {
    final request = AuthorizationTokenRequest(
      config.clientId,
      config.redirectUri,
      issuer: config.issuer,
      serviceConfiguration: config.endpoints == null
          ? null
          : AuthorizationServiceConfiguration(
              authorizationEndpoint: config.endpoints!.authorizationEndpoint,
              tokenEndpoint: config.endpoints!.tokenEndpoint,
            ),
      scopes: config.scopes,
    );
    try {
      final response = await _appAuth.authorizeAndExchangeCode(request);
      return _bundleFromResponse(response);
    } on FlutterAppAuthUserCancelledException catch (e) {
      throw OAuthError(
        kind: 'access_denied',
        message: 'User cancelled the sign-in flow.',
        cause: e,
      );
    } on FlutterAppAuthPlatformException catch (e) {
      throw OAuthError(
        kind: _classifyAppAuthError(e),
        message: e.message ?? 'AppAuth platform error',
        cause: e,
      );
    }
  }

  @override
  Future<void> signOut({
    required OAuthClientConfig config,
    String? idTokenHint,
  }) async {
    // flutter_appauth's endSession requires an issuer-discovered end-session
    // endpoint. We treat sign-out as best-effort and always clear local tokens
    // via OAuthTokenStore.wipe at the call site.
  }

  @override
  Future<AuthBundle> refresh({
    required OAuthClientConfig config,
    required String refreshToken,
  }) async {
    final request = TokenRequest(
      config.clientId,
      config.redirectUri,
      issuer: config.issuer,
      serviceConfiguration: config.endpoints == null
          ? null
          : AuthorizationServiceConfiguration(
              authorizationEndpoint: config.endpoints!.authorizationEndpoint,
              tokenEndpoint: config.endpoints!.tokenEndpoint,
            ),
      scopes: config.scopes,
      refreshToken: refreshToken,
      grantType: 'refresh_token',
    );
    try {
      final response = await _appAuth.token(request);
      return _bundleFromTokenResponse(response, fallbackRefresh: refreshToken);
    } on FlutterAppAuthPlatformException catch (e) {
      throw OAuthError(
        kind: _classifyAppAuthError(e),
        message: e.message ?? 'AppAuth refresh error',
        cause: e,
      );
    }
  }

  AuthBundle _bundleFromResponse(AuthorizationTokenResponse response) {
    final accessToken = response.accessToken;
    if (accessToken == null) {
      throw const OAuthError(
        kind: 'invalid_request',
        message: 'AppAuth returned no access token.',
      );
    }
    return AuthBundle(
      accessToken: accessToken,
      refreshToken: response.refreshToken,
      expiresAt:
          response.accessTokenExpirationDateTime ??
          DateTime.now().add(const Duration(hours: 1)),
      idToken: response.idToken,
    );
  }

  AuthBundle _bundleFromTokenResponse(
    TokenResponse response, {
    required String fallbackRefresh,
  }) {
    final accessToken = response.accessToken;
    if (accessToken == null) {
      throw const OAuthError(
        kind: 'invalid_grant',
        message: 'AppAuth refresh returned no access token.',
      );
    }
    return AuthBundle(
      accessToken: accessToken,
      // Some IdPs (incl. Microsoft) rotate refresh tokens on every refresh;
      // others omit a fresh one when the existing token remains valid.
      refreshToken: response.refreshToken ?? fallbackRefresh,
      expiresAt:
          response.accessTokenExpirationDateTime ??
          DateTime.now().add(const Duration(hours: 1)),
      idToken: response.idToken,
    );
  }

  String _classifyAppAuthError(FlutterAppAuthPlatformException e) {
    final lower = (e.message ?? '').toLowerCase();
    if (lower.contains('consent_required') ||
        lower.contains('aadsts65001') ||
        lower.contains('admin consent')) {
      return 'consent_required';
    }
    if (lower.contains('invalid_grant')) {
      return 'invalid_grant';
    }
    if (lower.contains('access_denied') || lower.contains('aadsts50105')) {
      return 'access_denied';
    }
    if (lower.contains('unauthorized_client') ||
        lower.contains('aadsts50020')) {
      return 'unauthorized_client';
    }
    return 'unknown';
  }
}
