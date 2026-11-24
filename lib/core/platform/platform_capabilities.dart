import 'package:flutter/foundation.dart';

import '../../l10n/l10n.dart';

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

  /// Explains a missing capability in the UI, e.g. "the Linux build", in the app's language.
  static String get buildName => switch (defaultTargetPlatform) {
    TargetPlatform.linux => L10n.current.platformBuildLinux,
    TargetPlatform.windows => L10n.current.platformBuildWindows,
    TargetPlatform.macOS => L10n.current.platformBuildMacos,
    _ => L10n.current.platformBuildThis,
  };

  /// The same as a prepositional phrase ("in the Linux build", "im Linux-Build").
  static String get inBuildName => switch (defaultTargetPlatform) {
    TargetPlatform.linux => L10n.current.platformInLinux,
    TargetPlatform.windows => L10n.current.platformInWindows,
    TargetPlatform.macOS => L10n.current.platformInMacos,
    _ => L10n.current.platformInThis,
  };
}
