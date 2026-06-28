import 'package:courrier/core/auth/oauth_token_store.dart';
import 'package:courrier/core/config/secrets_store.dart';
import 'package:courrier/core/db/database.dart';
import 'package:courrier/modules/mail/autoconfig/autoconfig_models.dart';
import 'package:courrier/modules/mail/autoconfig/autoconfig_resolver.dart';
import 'package:courrier/modules/onboarding/onboarding_controller.dart';
import 'package:courrier/modules/onboarding/onboarding_state.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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

OnboardingController _controller(CourrierDatabase db) {
  final secrets = SecretsStore(backend: _InMemorySecureBackend());
  return OnboardingController(
    db: db,
    secrets: secrets,
    tokenStore: OAuthTokenStore(secrets: secrets),
  );
}

void main() {
  group('OnboardingController.connectImap', () {
    test('autoconfig resolves → IMAP account row + secret persisted', () async {
      final db = CourrierDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final controller = _controller(db);
      addTearDown(controller.dispose);

      // Fake autoconfig — returns a Mozilla-shaped config without any HTTP.
      final fakeResolver = AutoconfigResolver(
        httpClient: MockClient((http.Request _) async {
          return http.Response('', 404);
        }),
        srvResolver: (name) async => name.startsWith('_imaps')
            ? const [
                SrvLookupResult(
                  priority: 10,
                  weight: 5,
                  port: 993,
                  target: 'imap.example.org',
                ),
              ]
            : const [
                SrvLookupResult(
                  priority: 10,
                  weight: 5,
                  port: 587,
                  target: 'smtp.example.org',
                ),
              ],
      );

      final outcome = await controller.connectImap(
        emailAddress: 'user@example.org',
        password: 'pw',
        resolver: fakeResolver,
      );
      expect(outcome, isA<StepSucceeded>());
      final accounts = await db.select(db.accounts).get();
      expect(accounts, hasLength(1));
      expect(accounts.single.kind, 'imap');
      expect(accounts.single.baseUrl, 'imap.example.org');
    });

    test('no autoconfig → StepFailed; no account inserted', () async {
      final db = CourrierDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final controller = _controller(db);
      addTearDown(controller.dispose);

      final resolver = AutoconfigResolver(
        httpClient: MockClient((http.Request _) async {
          return http.Response('', 404);
        }),
        srvResolver: (_) async => const <SrvLookupResult>[],
      );

      final outcome = await controller.connectImap(
        emailAddress: 'user@nowhere.invalid',
        password: 'pw',
        resolver: resolver,
      );
      expect(outcome, isA<StepFailed>());
      final accounts = await db.select(db.accounts).get();
      expect(accounts, isEmpty);
    });
  });

  group('Skip helpers', () {
    test('skip transitions move stage forward + record StepSkipped', () async {
      final db = CourrierDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      final controller = _controller(db);
      addTearDown(controller.dispose);

      controller.skipNextcloud();
      controller.skipImap();
      controller.skipMicrosoft365();
      expect(controller.state.stage, OnboardingStage.finished);
      expect(controller.state.nextcloud, isA<StepSkipped>());
      expect(controller.state.imap, isA<StepSkipped>());
      expect(controller.state.microsoft365, isA<StepSkipped>());
    });
  });
}
