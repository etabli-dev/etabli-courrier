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
    expect(imported, 2);
    expect(fresh.getString('pref.theme.mode'), 'dark');
    expect(fresh.getInt('pref.sync.interval_minutes'), 30);
    expect(fresh.getBool('pref.lock.enabled'), isNull);
  });

  test('Importer skips non-pref keys', () async {
    final store = await PreferencesStore.open();
    final json = await const SettingsExporter().exportAsJson(store);

    SharedPreferences.setMockInitialValues({});
    final fresh = await PreferencesStore.open();
    final imported = await const SettingsImporter().importFromJson(json, fresh);
    // Only the 2 non-security namespaced keys land — the unprefixed one is filtered out.
    expect(imported, 2);
    final shared = await SharedPreferences.getInstance();
    expect(shared.getKeys(), isNot(contains('unprefixed.junk')));
  });
  test(
    'unknown version and invalid value never partially change preferences',
    () async {
      final store = await PreferencesStore.open();
      for (final source in [
        '{"version":99,"preferences":{"pref.theme.mode":"light"}}',
        '{"version":1,"preferences":{"pref.theme.mode":"light","pref.bad":[]}}',
      ]) {
        await expectLater(
          const SettingsImporter().importFromJson(source, store),
          throwsFormatException,
        );
        expect(store.getString('pref.theme.mode'), 'dark');
      }
      await const SettingsImporter().importFromJson(
        '{"version":1,"preferences":{"pref.lock.enabled":false}}',
        store,
      );
      expect(store.getBool('pref.lock.enabled'), isTrue);
    },
  );
}
