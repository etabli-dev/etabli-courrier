import 'package:shared_preferences/shared_preferences.dart';

// Non-sensitive central preferences. Anything user-tunable that is NOT a
// secret. Secrets go to SecretsStore.
//
// All keys are namespaced 'pref.<area>.<name>' so future imports/exports (M11)
// can filter cleanly.
class PreferencesStore {
  PreferencesStore._(this._backend);

  static Future<PreferencesStore> open() async {
    final backend = await SharedPreferences.getInstance();
    return PreferencesStore._(backend);
  }

  final SharedPreferences _backend;

  // Generic typed helpers — areas (theme, sync, mail, …) wrap these so the key
  // strings live in one place.
  Future<bool> setString(String key, String value) =>
      _backend.setString(_check(key), value);
  String? getString(String key) => _backend.getString(_check(key));

  Future<bool> setBool(String key, {required bool value}) =>
      _backend.setBool(_check(key), value);
  bool? getBool(String key) => _backend.getBool(_check(key));

  Future<bool> setInt(String key, int value) =>
      _backend.setInt(_check(key), value);
  int? getInt(String key) => _backend.getInt(_check(key));

  Future<bool> remove(String key) => _backend.remove(_check(key));

  Future<void> reload() => _backend.reload();

  Map<String, Object?> exportAll() {
    return {
      for (final key in _backend.getKeys())
        if (key.startsWith('pref.')) key: _backend.get(key),
    };
  }

  String _check(String key) {
    if (!key.startsWith('pref.')) {
      throw ArgumentError.value(
        key,
        'key',
        "Preference keys must be namespaced 'pref.<area>.<name>'.",
      );
    }
    return key;
  }
}
