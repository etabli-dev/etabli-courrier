import 'dart:io';
import 'dart:ui' as ui;
import 'package:courrier/core/db/database.dart';
import 'package:courrier/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CourrierDatabase db;
  setUpAll(() async {
    final font = Platform.environment['COURRIER_TEST_FONT'];
    if (font != null) {
      final data = await File(font).readAsBytes();
      for (final family in ['Menlo', 'Roboto']) {
        final loader = FontLoader(family)
          ..addFont(Future.value(ByteData.sublistView(data)));
        await loader.load();
      }
    }
    final icons = File(
      'build/unit_test_assets/fonts/MaterialIcons-Regular.otf',
    );
    if (await icons.exists()) {
      final data = await icons.readAsBytes();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(Future.value(ByteData.sublistView(data)))).load();
    }
  });
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    final account = await db
        .into(db.accounts)
        .insert(AccountsCompanion.insert(kind: 'local', displayName: 'Local'));
    await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            accountId: account,
            kind: 'notes',
            displayName: 'Notebook',
          ),
        );
  });

  Future<void> shortcut(
    WidgetTester tester,
    LogicalKeyboardKey key, {
    bool meta = false,
    bool shift = false,
  }) async {
    final modifier = meta
        ? LogicalKeyboardKey.metaLeft
        : LogicalKeyboardKey.controlLeft;
    await tester.sendKeyDownEvent(modifier);
    if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(key);
    if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyUpEvent(modifier);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'desktop shortcuts navigate, create a note and leave ordinary typing alone',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final screenshotKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: screenshotKey,
          child: CourrierApp(database: db),
        ),
      );
      Future<void> capture(String filename) async {
        final folder = Platform.environment['COURRIER_SCREENSHOT_DIR'];
        if (folder == null) return;
        final boundary =
            screenshotKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage();
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(folder).create(recursive: true);
          await File(
            '$folder/$filename.png',
          ).writeAsBytes(data!.buffer.asUint8List());
          image.dispose();
        });
      }

      await tester.pumpAndSettle();
      await shortcut(tester, LogicalKeyboardKey.digit6);
      expect(find.text('courrier · notes'), findsOneWidget);
      await capture('desktop-notes');
      await shortcut(tester, LogicalKeyboardKey.keyN, meta: true);
      expect(find.text('New note'), findsOneWidget);
      final fields = find.byType(TextField);
      expect(fields, findsWidgets);
      await tester.enterText(fields.first, 'My note 123');
      expect(find.text('My note 123'), findsOneWidget);
      expect(find.text('New note'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await shortcut(tester, LogicalKeyboardKey.digit3, meta: true);
      expect(find.text('courrier · contacts'), findsOneWidget);
      await shortcut(tester, LogicalKeyboardKey.comma);
      expect(find.text('Settings'), findsWidgets);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await shortcut(tester, LogicalKeyboardKey.keyA, shift: true);
      expect(find.text('Accounts'), findsWidgets);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.f1);
      await tester.pumpAndSettle();
      expect(find.text('Keyboard shortcuts'), findsOneWidget);
      await capture('keyboard-shortcuts');
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      final closing = db.close();
      await tester.pump(const Duration(milliseconds: 1));
      await closing;
    },
  );
}
