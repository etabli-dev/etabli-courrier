import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/appearance.dart';

/// The user's appearance (app language, mode and accent), stored under the keys shared with the other
/// Établi apps (`app.language`, `appearance.mode`, `appearance.accent`). Missing or unknown stored values
/// fall back to System and Coder blue. Changes apply at once: the app root listens to this notifier.
class AppearanceController extends ChangeNotifier {
  AppearanceController._(this._prefs)
    : _mode = AppearanceMode.fromStored(_prefs?.getString(AppearanceKeys.mode)),
      _accent = AccentChoice.fromStored(
        _prefs?.getString(AppearanceKeys.accent),
      ),
      _language = AppLanguage.fromStored(
        _prefs?.getString(AppearanceKeys.language),
      );

  /// Defaults only, without storage (tests and the demo shell).
  AppearanceController.memory() : this._(null);

  static Future<AppearanceController> load() async {
    try {
      return AppearanceController._(await SharedPreferences.getInstance());
    } on Object {
      // Storage unavailable: run with the defaults rather than not at all.
      return AppearanceController.memory();
    }
  }

  final SharedPreferences? _prefs;
  AppearanceMode _mode;
  AccentChoice _accent;
  AppLanguage _language;

  AppearanceMode get mode => _mode;
  AccentChoice get accent => _accent;
  AppLanguage get language => _language;

  Future<void> setMode(AppearanceMode mode) async {
    _mode = mode;
    notifyListeners();
    await _prefs?.setString(AppearanceKeys.mode, mode.name);
  }

  Future<void> setAccent(AccentChoice accent) async {
    _accent = accent;
    notifyListeners();
    await _prefs?.setString(AppearanceKeys.accent, accent.name);
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    notifyListeners();
    await _prefs?.setString(AppearanceKeys.language, language.name);
  }
}

/// Makes the [AppearanceController] available below the app root.
class AppearanceScope extends InheritedNotifier<AppearanceController> {
  const AppearanceScope({
    required AppearanceController controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static AppearanceController? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppearanceScope>()?.notifier;
}
