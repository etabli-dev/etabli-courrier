import 'package:flutter/material.dart';

import '../config/preferences_store.dart';
import 'biometric_app_lock_guard.dart';

class AppSecurity {
  static final revision = ValueNotifier(0);
  static bool authenticating = false;
  static Future<bool> unlock() async {
    if (authenticating) return false;
    authenticating = true;
    try {
      return await BiometricAppLockGuard().unlock();
    } finally {
      authenticating = false;
    }
  }
}

class AppLockHost extends StatefulWidget {
  const AppLockHost({required this.child, super.key});
  final Widget child;
  @override
  State<AppLockHost> createState() => _AppLockHostState();
}

class _AppLockHostState extends State<AppLockHost> with WidgetsBindingObserver {
  bool _enabled = false, _locked = true, _ready = false, _busy = false;
  String? _error;
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
      final enabled = prefs.getBool('pref.lock.enabled') ?? false;
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
          _error = 'Could not read app-lock settings. Retry to continue.';
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
        _error = unlocked
            ? null
            : 'Authentication was cancelled or unavailable. Please retry.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
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
                    Text(
                      _error ??
                          (_ready
                              ? 'Unlock courrier'
                              : 'Loading security settings…'),
                    ),
                    const SizedBox(height: 16),
                    if (!_ready && _error != null)
                      FilledButton(
                        onPressed: _refresh,
                        child: const Text('Retry'),
                      ),
                    if (_ready)
                      FilledButton(
                        onPressed: _busy ? null : _unlock,
                        child: Text(_busy ? 'Authenticating…' : 'Unlock'),
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
