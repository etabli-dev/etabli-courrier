import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

import '../config/secrets_store.dart';

// App lock contract. M11 ships two implementations:
//   * PinAppLockGuard       — user-set PIN, derived with PBKDF2 + per-install
//                             salt; the hash lives in SecretsStore.
//   * BiometricAppLockGuard — Touch ID / Face ID / Fingerprint via local_auth.
//
// Production uses platform device authentication, including the device passcode.
// The PIN helper remains available for legacy data compatibility. The interface is one method (`unlock`) so the
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

/// PBKDF2-derived PIN, persisted via SecretsStore. We use a constant
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
  static const String _recordSlot = 'app_lock.pin_v2';

  @override
  AppLockMethod get method => AppLockMethod.pin;

  @override
  Future<bool> isConfigured() async {
    final record = await secrets.read(_slotAccount, _recordSlot);
    if (record != null) return record.isNotEmpty;
    final hash = await secrets.read(_slotAccount, _pinHashSlot);
    return hash != null && hash.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    if (!RegExp(r'^\d{4,12}$').hasMatch(pin)) {
      throw const FormatException('Use 4 to 12 digits.');
    }
    await _storeDerivedPin(pin);
  }

  Future<void> _storeDerivedPin(String pin) async {
    final random = Random.secure();
    final salt = base64Encode(
      List<int>.generate(16, (_) => random.nextInt(256)),
    );
    final hash = await Isolate.run(() => derivePinKey(pin, salt, 600000));
    await secrets.write(
      _slotAccount,
      _recordSlot,
      jsonEncode({'version': 2, 'salt': salt, 'hash': hash}),
    );
  }

  Future<void> disable() async {
    // An explicit empty v2 record also disables any retained legacy slots.
    await secrets.write(_slotAccount, _recordSlot, '');
  }

  @override
  Future<bool> unlock() async {
    final record = await secrets.read(_slotAccount, _recordSlot);
    if (record != null && record.isEmpty) return false;
    final pin = await promptForPin();
    if (pin == null || pin.isEmpty) return false;
    if (record != null) {
      final Map<String, dynamic> value;
      try {
        final decoded = jsonDecode(record);
        if (decoded is! Map<String, dynamic>) return false;
        value = decoded;
      } on FormatException {
        return false;
      }
      if (value['version'] != 2 ||
          value['salt'] is! String ||
          value['hash'] is! String) {
        return false;
      }
      final salt = value['salt'] as String;
      try {
        if (base64Decode(salt).length != 16) return false;
      } on FormatException {
        return false;
      }
      final candidate = await Isolate.run(
        () => derivePinKey(pin, salt, 600000),
      );
      return _constantTimeEqual(candidate, value['hash'] as String);
    }
    final hash = await secrets.read(_slotAccount, _pinHashSlot);
    final salt = await secrets.read(_slotAccount, _saltSlot);
    if (hash == null || hash.isEmpty || salt == null) return false;
    final candidate = sha256.convert(utf8.encode('$salt:$pin')).toString();
    if (!_constantTimeEqual(candidate, hash)) return false;
    await _storeDerivedPin(pin);
    return true;
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

/// PBKDF2-HMAC-SHA256, one 32-byte output block. The UI runs it off the main isolate.
String derivePinKey(String pin, String saltBase64, int iterations) {
  if (iterations < 1 || iterations > 600000) {
    throw ArgumentError('Invalid work factor');
  }
  final hmac = Hmac(sha256, utf8.encode(pin));
  var u = hmac.convert([...base64Decode(saltBase64), 0, 0, 0, 1]).bytes;
  final output = List<int>.from(u);
  for (var round = 1; round < iterations; round++) {
    u = hmac.convert(u).bytes;
    for (var i = 0; i < output.length; i++) {
      output[i] ^= u[i];
    }
  }
  return output.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
