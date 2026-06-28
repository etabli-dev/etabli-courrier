import 'package:courrier/core/auth/oauth_provider.dart';
import 'package:courrier/core/auth/oauth_token_store.dart';
import 'package:courrier/core/config/secrets_store.dart';
import 'package:courrier/modules/mail/backend/imap_mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_backend.dart';
import 'package:courrier/modules/mail/backend/mail_credentials.dart';
import 'package:courrier/modules/mail/providers/microsoft365/m365_backend.dart';
import 'package:courrier/modules/mail/providers/microsoft365/m365_config.dart';
import 'package:courrier/modules/mail/providers/microsoft365/tenant_state.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOAuthProvider implements OAuthProvider {
  int signInCalls = 0;
  int refreshCalls = 0;
  bool failConsentOnSignIn = false;
  bool failRefresh = false;

  @override
  Future<AuthBundle> signIn(OAuthClientConfig config) async {
    signInCalls += 1;
    if (failConsentOnSignIn) {
      throw const OAuthError(
        kind: 'consent_required',
        message: 'AADSTS65001 admin consent required',
      );
    }
    return AuthBundle(
      accessToken: 'access-$signInCalls',
      refreshToken: 'refresh-$signInCalls',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  @override
  Future<AuthBundle> refresh({
    required OAuthClientConfig config,
    required String refreshToken,
  }) async {
    refreshCalls += 1;
    if (failRefresh) {
      throw const OAuthError(
        kind: 'invalid_grant',
        message: 'refresh token revoked',
      );
    }
    return AuthBundle(
      accessToken: 'refreshed-$refreshCalls',
      refreshToken: 'refresh-rotated-$refreshCalls',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  @override
  Future<void> signOut({
    required OAuthClientConfig config,
    String? idTokenHint,
  }) async {}
}

class _InMemorySecureBackend implements FlutterSecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _data[key];

  @override
  Future<Map<String, String>> readAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => Map<String, String>.from(_data);

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.remove(key);
  }

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _data.clear();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _StubImapBackend implements ImapMailBackend {
  XoauthBearerCredentials? lastCredentials;
  int connectCalls = 0;
  int listFoldersCalls = 0;

  @override
  Future<void> connect(MailCredentials credentials) async {
    connectCalls += 1;
    if (credentials is XoauthBearerCredentials) {
      lastCredentials = credentials;
    }
  }

  @override
  Future<List<MailFolderHandle>> listFolders() async {
    listFoldersCalls += 1;
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

OAuthTokenStore _store() {
  return OAuthTokenStore(
    secrets: SecretsStore(backend: _InMemorySecureBackend()),
  );
}

M365Backend _backend({
  required _FakeOAuthProvider oauth,
  required _StubImapBackend imap,
  required OAuthTokenStore store,
}) => M365Backend(
  config: const M365Config(clientId: 'cli'),
  oauthProvider: oauth,
  tokenStore: store,
  accountId: 42,
  userEmail: 'user@example.com',
  imapBackend: imap,
);

void main() {
  group('M365Backend.signInAndConnect', () {
    test(
      'happy path: signs in, persists refresh, connects IMAP with bearer',
      () async {
        final oauth = _FakeOAuthProvider();
        final imap = _StubImapBackend();
        final store = _store();
        final backend = _backend(oauth: oauth, imap: imap, store: store);

        final state = await backend.signInAndConnect();
        expect(state, isA<TenantConnected>());
        expect(oauth.signInCalls, 1);
        expect(imap.connectCalls, 1);
        expect(imap.lastCredentials, isNotNull);
        expect(imap.lastCredentials!.accessToken, startsWith('access-'));
        expect(await store.readRefreshToken(42), startsWith('refresh-'));
      },
    );

    test(
      'admin-consent rejection routes to AdminConsentRequired (no crash)',
      () async {
        final oauth = _FakeOAuthProvider()..failConsentOnSignIn = true;
        final imap = _StubImapBackend();
        final store = _store();
        final backend = _backend(oauth: oauth, imap: imap, store: store);

        final state = await backend.signInAndConnect();
        expect(state, isA<AdminConsentRequired>());
        expect(imap.connectCalls, 0);
      },
    );
  });

  group('M365Backend.silentReconnect', () {
    test('no persisted refresh → TenantAuthFailedGeneric', () async {
      final oauth = _FakeOAuthProvider();
      final imap = _StubImapBackend();
      final store = _store();
      final backend = _backend(oauth: oauth, imap: imap, store: store);

      final state = await backend.silentReconnect();
      expect(state, isA<TenantAuthFailedGeneric>());
      expect(oauth.refreshCalls, 0);
    });

    test(
      'persisted refresh → refresh + IMAP reconnect with new token',
      () async {
        final oauth = _FakeOAuthProvider();
        final imap = _StubImapBackend();
        final store = _store();
        final backend = _backend(oauth: oauth, imap: imap, store: store);

        await backend.signInAndConnect();
        imap.connectCalls = 0;

        final state = await backend.silentReconnect();
        expect(state, isA<TenantConnected>());
        expect(oauth.refreshCalls, 1);
        expect(imap.connectCalls, 1);
        expect(imap.lastCredentials!.accessToken, startsWith('refreshed-'));
      },
    );

    test(
      'refresh failure routes to TenantAuthFailedGeneric (no crash)',
      () async {
        final oauth = _FakeOAuthProvider();
        final imap = _StubImapBackend();
        final store = _store();
        final backend = _backend(oauth: oauth, imap: imap, store: store);

        await backend.signInAndConnect();
        oauth.failRefresh = true;
        final state = await backend.silentReconnect();
        expect(state, isA<TenantAuthFailedGeneric>());
      },
    );
  });
}
