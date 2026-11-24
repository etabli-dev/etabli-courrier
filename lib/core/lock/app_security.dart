import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../config/preferences_store.dart';
import '../platform/platform_capabilities.dart';
import 'biometric_app_lock_guard.dart';

class AppSecurity {
  static final revision = ValueNotifier(0);
  static bool authenticating = false;
  static Future<bool> unlock() async {
    if (authenticating || !PlatformCapabilities.deviceAuthentication) {
      return false;
    }
    authenticating = true;
    try {
      return await BiometricAppLockGuard().unlock();
    } finally {
      authenticating = false;
    }
  }
}

/// Why the lock screen shows an error instead of its title; localized when shown.
enum _LockError { settingsUnreadable, authenticationFailed }

class AppLockHost extends StatefulWidget {
  const AppLockHost({required this.child, super.key});
  final Widget child;
  @override
  State<AppLockHost> createState() => _AppLockHostState();
}

class _AppLockHostState extends State<AppLockHost> with WidgetsBindingObserver {
  bool _enabled = false, _locked = true, _ready = false, _busy = false;
  _LockError? _error;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppSecurity.revision.addListener(_refresh);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppSecurity.revision.removeListener(_refresh);
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final prefs = await PreferencesStore.open();
      // Without device authentication a stored lock could never be opened.
      final enabled =
          PlatformCapabilities.deviceAuthentication &&
          (prefs.getBool('pref.lock.enabled') ?? false);
      if (mounted) {
        setState(() {
          _enabled = enabled;
          _locked = enabled && (!_ready || _locked);
          _ready = true;
          _error = null;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _locked = true;
          _error = _LockError.settingsUnreadable;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_enabled &&
        !AppSecurity.authenticating &&
        state != AppLifecycleState.resumed &&
        mounted) {
      setState(() => _locked = true);
    }
  }

  Future<void> _unlock() async {
    setState(() => _busy = true);
    final unlocked = await AppSecurity.unlock();
    if (mounted) {
      setState(() {
        _busy = false;
        _locked = !unlocked;
        _error = unlocked ? null : _LockError.authenticationFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Stack(
      children: [
        Offstage(offstage: _locked || !_ready, child: widget.child),
        if (_locked || !_ready)
          Positioned.fill(
            child: Material(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, size: 40),
                      const SizedBox(height: 16),
                      Text(switch (_error) {
                        _LockError.settingsUnreadable =>
                          l10n.appLockSettingsFailed,
                        _LockError.authenticationFailed =>
                          l10n.appLockAuthFailed,
                        null =>
                          _ready ? l10n.appLockTitle : l10n.appLockLoading,
                      }),
                      const SizedBox(height: 16),
                      if (!_ready && _error != null)
                        FilledButton(
                          onPressed: _refresh,
                          child: Text(l10n.commonRetry),
                        ),
                      if (_ready)
                        FilledButton(
                          onPressed: _busy ? null : _unlock,
                          child: Text(
                            _busy
                                ? l10n.appLockAuthenticating
                                : l10n.appLockUnlock,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
