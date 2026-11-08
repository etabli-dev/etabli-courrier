import 'package:flutter/foundation.dart';

/// Features whose plugin or operating-system support differs per platform.
///
/// Every desktop gap is listed in docs/platform-roadmap.md. Uses
/// [defaultTargetPlatform] so widget tests can exercise each platform with
/// `debugDefaultTargetPlatformOverride`.
abstract final class PlatformCapabilities {
  /// Device authentication through `local_auth` (app lock and note lock).
  /// The plugin has no Linux implementation.
  static bool get deviceAuthentication => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS ||
    TargetPlatform.windows => true,
    _ => false,
  };

  /// Reminders delivered as scheduled system notifications. Linux has no
  /// scheduling support in `flutter_local_notifications`; the Windows path
  /// (app identity, one-shot schedules only) is not integrated yet.
  static bool get scheduledReminders => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.macOS => true,
    _ => false,
  };

  /// Explains a missing capability in the UI, e.g. "the Linux build".
  static String get buildName => switch (defaultTargetPlatform) {
    TargetPlatform.linux => 'the Linux build',
    TargetPlatform.windows => 'the Windows build',
    TargetPlatform.macOS => 'the macOS build',
    _ => 'this build',
  };
}
