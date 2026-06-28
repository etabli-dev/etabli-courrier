import 'package:courrier/core/config/secrets_store.dart';
import 'package:courrier/core/lock/app_lock_guard.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  PinAppLockGuard makeGuard({required Future<String?> Function() prompt}) {
    return PinAppLockGuard(
      secrets: SecretsStore(backend: _InMemorySecureBackend()),
      promptForPin: prompt,
    );
  }

  test('isConfigured returns false until setPin is called', () async {
    final guard = makeGuard(prompt: () async => null);
    expect(await guard.isConfigured(), isFalse);
    await guard.setPin('1234');
    expect(await guard.isConfigured(), isTrue);
  });

  test('unlock returns true on correct PIN, false on wrong', () async {
    String? attempt;
    final guard = makeGuard(prompt: () async => attempt);
    await guard.setPin('1234');

    attempt = '1234';
    expect(await guard.unlock(), isTrue);

    attempt = '0000';
    expect(await guard.unlock(), isFalse);
  });

  test('unlock without configured PIN returns false', () async {
    final guard = makeGuard(prompt: () async => '1234');
    expect(await guard.unlock(), isFalse);
  });

  test('disable clears the stored PIN — subsequent unlock fails', () async {
    final guard = makeGuard(prompt: () async => '1234');
    await guard.setPin('1234');
    await guard.disable();
    expect(await guard.isConfigured(), isFalse);
    expect(await guard.unlock(), isFalse);
  });
}
