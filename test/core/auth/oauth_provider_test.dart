import 'package:courrier/core/auth/oauth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthBundle.willExpireSoon', () {
    test('returns true when within the default 1-minute margin', () {
      final bundle = AuthBundle(
        accessToken: 'a',
        refreshToken: 'r',
        expiresAt: DateTime.now().add(const Duration(seconds: 30)),
      );
      expect(bundle.willExpireSoon(), isTrue);
    });

    test('returns false when the access token is comfortably fresh', () {
      final bundle = AuthBundle(
        accessToken: 'a',
        refreshToken: 'r',
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      expect(bundle.willExpireSoon(), isFalse);
    });

    test('returns true once the access token is already expired', () {
      final bundle = AuthBundle(
        accessToken: 'a',
        refreshToken: 'r',
        expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
      );
      expect(bundle.willExpireSoon(), isTrue);
    });
  });

  group('OAuthError.toNetError', () {
    test('consent_required → UnauthorizedError', () {
      final error = const OAuthError(
        kind: 'consent_required',
        message: 'admin consent required',
      ).toNetError();
      expect(error.runtimeType.toString(), 'UnauthorizedError');
    });

    test('access_denied → UnauthorizedError', () {
      final error = const OAuthError(
        kind: 'access_denied',
        message: 'user denied',
      ).toNetError();
      expect(error.runtimeType.toString(), 'UnauthorizedError');
    });

    test('unknown → UnknownNetError', () {
      final error = const OAuthError(
        kind: 'unknown',
        message: 'something',
      ).toNetError();
      expect(error.runtimeType.toString(), 'UnknownNetError');
    });
  });
}
