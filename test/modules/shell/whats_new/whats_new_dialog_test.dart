import 'package:courrier/core/config/preferences_store.dart';
import 'package:courrier/modules/shell/whats_new/whats_new_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('shouldShow returns true on first run; false after markSeen', () async {
    final prefs = await PreferencesStore.open();
    final service = WhatsNewService(
      preferences: prefs,
      currentVersion: 'v0.1.0',
      notes: const ['Mail', 'Calendar'],
    );
    expect(await service.shouldShow(), isTrue);
    await service.markSeen();
    expect(await service.shouldShow(), isFalse);
  });

  test('A newer version makes shouldShow true again', () async {
    final prefs = await PreferencesStore.open();
    final firstRun = WhatsNewService(
      preferences: prefs,
      currentVersion: 'v0.1.0',
      notes: const [],
    );
    await firstRun.markSeen();

    final secondRun = WhatsNewService(
      preferences: prefs,
      currentVersion: 'v0.2.0',
      notes: const [],
    );
    expect(await secondRun.shouldShow(), isTrue);
  });
}
