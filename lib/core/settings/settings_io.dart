import 'dart:convert';

import 'package:meta/meta.dart';

import '../config/preferences_store.dart';

// Settings export / import. Roundtrips non-sensitive preferences from
// PreferencesStore as a JSON blob. Secrets (OAuth tokens, app passwords)
// stay in SecretsStore and never leave the device.
//
// The JSON envelope carries a version field so future migrations can keep
// the roundtrip lossless.

@immutable
class SettingsExportEnvelope {
  const SettingsExportEnvelope({
    required this.version,
    required this.preferences,
  });

  factory SettingsExportEnvelope.fromJson(Map<String, dynamic> json) {
    return SettingsExportEnvelope(
      version: (json['version'] as num).toInt(),
      preferences: Map<String, Object?>.from(
        (json['preferences'] as Map<dynamic, dynamic>?) ?? const {},
      ),
    );
  }

  final int version;
  final Map<String, Object?> preferences;

  Map<String, dynamic> toJson() => {
    'version': version,
    'preferences': preferences,
  };
}

class SettingsExporter {
  const SettingsExporter();
  static const int currentVersion = 1;

  Future<String> exportAsJson(PreferencesStore store) async {
    final envelope = SettingsExportEnvelope(
      version: currentVersion,
      preferences: store.exportAll(),
    );
    return jsonEncode(envelope.toJson());
  }
}

class SettingsImporter {
  const SettingsImporter();

  Future<int> importFromJson(String jsonSource, PreferencesStore store) async {
    final decoded = jsonDecode(jsonSource);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('settings envelope is not an object');
    }
    final envelope = SettingsExportEnvelope.fromJson(decoded);
    var imported = 0;
    for (final entry in envelope.preferences.entries) {
      final key = entry.key;
      final value = entry.value;
      if (!key.startsWith('pref.')) {
        continue;
      }
      if (value is bool) {
        await store.setBool(key, value: value);
        imported += 1;
      } else if (value is int) {
        await store.setInt(key, value);
        imported += 1;
      } else if (value is String) {
        await store.setString(key, value);
        imported += 1;
      }
    }
    return imported;
  }
}
