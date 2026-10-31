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
      preferences: Map.fromEntries(
        store.exportAll().entries.where((e) => !e.key.startsWith('pref.lock.')),
      ),
    );
    return jsonEncode(envelope.toJson());
  }
}

class SettingsImporter {
  const SettingsImporter();

  Future<int> importFromJson(String jsonSource, PreferencesStore store) async {
    if (jsonSource.length > 65536) {
      throw const FormatException('Settings exceed 64 KiB.');
    }
    final decoded = jsonDecode(jsonSource);
    if (decoded is! Map<String, dynamic> ||
        decoded['version'] != SettingsExporter.currentVersion ||
        decoded['preferences'] is! Map<String, dynamic>) {
      throw const FormatException('Unsupported settings format or version.');
    }
    final values = decoded['preferences'] as Map<String, dynamic>;
    final accepted = <String, Object>{};
    for (final entry in values.entries) {
      if (!entry.key.startsWith('pref.') ||
          entry.key.startsWith('pref.lock.')) {
        continue;
      }
      final value = entry.value;
      if (entry.key.length > 200 ||
          !(value is bool || value is int || value is String)) {
        throw const FormatException('Invalid preference value.');
      }
      accepted[entry.key] = value as Object;
    }
    final previous = store.exportAll();
    Future<void> write(String key, Object? value) async {
      final bool saved;
      if (value is bool) {
        saved = await store.setBool(key, value: value);
      } else if (value is int) {
        saved = await store.setInt(key, value);
      } else if (value is String) {
        saved = await store.setString(key, value);
      } else {
        saved = await store.remove(key);
      }
      if (!saved) throw StateError('Could not persist settings.');
    }

    try {
      for (final entry in accepted.entries) {
        await write(entry.key, entry.value);
      }
    } catch (_) {
      for (final key in accepted.keys) {
        await write(key, previous[key]);
      }
      rethrow;
    }
    return accepted.length;
  }
}
