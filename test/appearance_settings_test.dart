import 'dart:io';

import 'package:courrier/core/bootstrap/sample_content_installer.dart';
import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/settings/appearance_controller.dart';
import 'package:courrier/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Settings → Appearance: the app language, mode and accent apply at once to the whole app and are stored
// under the keys shared with the other Établi apps.
void main() {
  late CourrierDatabase db;
  setUp(() async {
    SharedPreferences.setMockInitialValues({'app.language': 'en'});
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    await SampleContentInstaller(bundle: _FileBundle()).installIfMissing(db);
  });

  testWidgets('language, mode and accent switch at once', (tester) async {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final appearance = await tester.runAsync(AppearanceController.load);
    await tester.pumpWidget(CourrierApp(database: db, appearance: appearance));
    await tester.pumpAndSettle();
    expect(find.text('calendar'), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Appearance'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey('settings.appearance.language')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch').last);
    await tester.pumpAndSettle();
    expect(find.text('Darstellung'), findsOneWidget);
    expect(find.text('Einstellungen'), findsWidgets);
    expect(find.text('Dunkel'), findsOneWidget);

    await tester.tap(find.text('Dunkel'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Darstellung'))).brightness,
      Brightness.dark,
    );
    final semantics = tester.ensureSemantics();
    await tester.tap(find.bySemanticsLabel('Violett'));
    await tester.pumpAndSettle();
    expect(
      Theme.of(tester.element(find.text('Darstellung'))).colorScheme.primary,
      const Color(0xFFB39DDB),
    );
    semantics.dispose();

    // Flutter's own strings follow too: the back button is "Zurück".
    expect(find.byTooltip('Zurück'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('kalender'), findsOneWidget);
    final prefs = await tester.runAsync(SharedPreferences.getInstance);
    expect(prefs!.getString('app.language'), 'de');
    expect(prefs.getString('appearance.mode'), 'dark');
    expect(prefs.getString('appearance.accent'), 'purple');
    expect(tester.takeException(), isNull);
    // Drift retains closed query streams until a zero-delay timer fires.
    final closing = db.close();
    await tester.pump(const Duration(milliseconds: 1));
    await closing;
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
  });
}

class _FileBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(await File(key).readAsBytes());
}
