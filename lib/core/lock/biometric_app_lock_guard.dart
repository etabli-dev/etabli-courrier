import 'package:local_auth/local_auth.dart';

import 'app_lock_guard.dart';

// Biometric lock backed by `local_auth`. The platform prompt does the actual
// authentication; we just route the result + treat OS-level UI cancellations
// the same way as a failed PIN entry.

class BiometricAppLockGuard implements AppLockGuard {
  BiometricAppLockGuard({LocalAuthentication? auth})
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  AppLockMethod get method => AppLockMethod.biometric;

  @override
  Future<bool> isConfigured() async {
    final supported = await _auth.isDeviceSupported();
    if (!supported) {
      return false;
    }
    final canCheck = await _auth.canCheckBiometrics;
    return canCheck;
  }

  @override
  Future<bool> unlock() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Unlock courrier',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } on Exception {
      return false;
    }
  }
}
