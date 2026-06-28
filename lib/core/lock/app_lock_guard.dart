import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../config/secrets_store.dart';

// App lock contract. M11 ships two implementations:
//   * PinAppLockGuard       — user-set PIN, hashed via SHA-256 + per-install
//                             salt; the hash lives in SecretsStore.
//   * BiometricAppLockGuard — Touch ID / Face ID / Fingerprint via local_auth.
//
// The shell composes them: if biometric is available + enabled, use it;
// otherwise fall back to PIN. The interface is one method (`unlock`) so the
// caller never branches on the mechanism.

enum AppLockMethod { pin, biometric }

@immutable
class LockState {
  const LockState({required this.method, required this.isConfigured});
  final AppLockMethod method;
  final bool isConfigured;
}

abstract class AppLockGuard {
  AppLockMethod get method;

  /// Whether the user has configured this lock method.
  Future<bool> isConfigured();

  /// Block until the user authenticates. Returns false on cancel/decline.
  Future<bool> unlock();
}

/// SHA-256 hashed PIN, persisted via the M1 SecretsStore. We use a constant
/// account id ("0") to keep the lock independent of any per-account secret.
class PinAppLockGuard implements AppLockGuard {
  PinAppLockGuard({required this.secrets, required this.promptForPin});

  final SecretsStore secrets;

  /// Injected so the production app shows a Material dialog and tests can
  /// drive deterministic PIN entry without a Flutter widget tree.
  final Future<String?> Function() promptForPin;

  static const int _slotAccount = 0;
  static const String _pinHashSlot = 'app_lock.pin_hash';
  static const String _saltSlot = 'app_lock.salt';

  @override
  AppLockMethod get method => AppLockMethod.pin;

  @override
  Future<bool> isConfigured() async {
    final hash = await secrets.read(_slotAccount, _pinHashSlot);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    final hash = _hash(pin, salt);
    await secrets.write(_slotAccount, _saltSlot, salt);
    await secrets.write(_slotAccount, _pinHashSlot, hash);
  }

  Future<void> disable() async {
    await secrets.write(_slotAccount, _pinHashSlot, '');
    await secrets.write(_slotAccount, _saltSlot, '');
  }

  @override
  Future<bool> unlock() async {
    final storedHash = await secrets.read(_slotAccount, _pinHashSlot);
    final salt = await secrets.read(_slotAccount, _saltSlot);
    if (storedHash == null || storedHash.isEmpty || salt == null) {
      return false;
    }
    final pin = await promptForPin();
    if (pin == null || pin.isEmpty) {
      return false;
    }
    final candidate = _hash(pin, salt);
    return _constantTimeEqual(candidate, storedHash);
  }

  String _generateSalt() {
    final bytes = List<int>.generate(
      16,
      (i) => (DateTime.now().microsecondsSinceEpoch + i * 31) & 0xff,
    );
    return base64Encode(bytes);
  }

  String _hash(String pin, String salt) {
    final input = utf8.encode('$salt:$pin');
    return sha256.convert(input).toString();
  }

  bool _constantTimeEqual(String a, String b) {
    if (a.length != b.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
