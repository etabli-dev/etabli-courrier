import 'package:courrier/core/config/preferences_store.dart';
import 'package:courrier/core/settings/settings_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'pref.theme.mode': 'dark',
      'pref.sync.interval_minutes': 30,
      'pref.lock.enabled': true,
      'unprefixed.junk': 'ignore me',
    });
  });

  test('Round-trip: exportAsJson → importFromJson reproduces values', () async {
    final store = await PreferencesStore.open();
    final json = await const SettingsExporter().exportAsJson(store);

    SharedPreferences.setMockInitialValues({});
    final fresh = await PreferencesStore.open();
    final imported = await const SettingsImporter().importFromJson(json, fresh);
    expect(imported, 3);
    expect(fresh.getString('pref.theme.mode'), 'dark');
    expect(fresh.getInt('pref.sync.interval_minutes'), 30);
    expect(fresh.getBool('pref.lock.enabled'), isTrue);
  });

  test('Importer skips non-pref keys', () async {
    final store = await PreferencesStore.open();
    final json = await const SettingsExporter().exportAsJson(store);

    SharedPreferences.setMockInitialValues({});
    final fresh = await PreferencesStore.open();
    final imported = await const SettingsImporter().importFromJson(json, fresh);
    // Only the 3 namespaced keys land — the unprefixed one is filtered out.
    expect(imported, 3);
    final shared = await SharedPreferences.getInstance();
    expect(shared.getKeys(), isNot(contains('unprefixed.junk')));
  });
}
