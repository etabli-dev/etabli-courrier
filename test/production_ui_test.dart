import 'dart:io';
import 'dart:ui' as ui;
import 'package:courrier/core/bootstrap/sample_content_installer.dart';
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
  var closed = false;
  setUpAll(() async {
    final font = Platform.environment['COURRIER_TEST_FONT'];
    if (font != null) {
      final bytes = await File(font).readAsBytes();
      for (final family in ['Menlo', 'Roboto']) {
        final loader = FontLoader(family)
          ..addFont(Future.value(ByteData.sublistView(bytes)));
        await loader.load();
      }
    }
  });
  setUpAll(() async {
    final font = File('build/unit_test_assets/fonts/MaterialIcons-Regular.otf');
    if (await font.exists()) {
      final bytes = await font.readAsBytes();
      await (FontLoader(
        'MaterialIcons',
      )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
    }
  });
  setUp(() async {
    closed = false;
    SharedPreferences.setMockInitialValues({});
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
    await SampleContentInstaller(bundle: _FileBundle()).installIfMissing(db);
  });
  tearDown(() async {
    if (!closed) await db.close();
  });
  testWidgets(
    'production phone notes, account form and settings render without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final key = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: CourrierApp(database: db),
        ),
      );
      await tester.pumpAndSettle();
      Future<void> capture(String name) async {
        expect(tester.takeException(), isNull);
        final dir = Platform.environment['COURRIER_SCREENSHOT_DIR'];
        if (dir == null) return;
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory(dir).create(recursive: true);
          await File(
            '$dir/$name.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }

      await tester.tap(find.byIcon(Icons.notes).last);
      await tester.pumpAndSettle();
      await capture('notes');
      await tester.tap(find.byTooltip('Accounts'));
      await tester.pumpAndSettle();
      await capture('accounts');
      await tester.tap(find.text('Connect Nextcloud'));
      await tester.pumpAndSettle();
      await capture('nextcloud');
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      await capture('settings');
      await tester.ensureVisible(find.text('Open-source licenses'));
      await tester.tap(find.text('Open-source licenses'));
      await tester.pumpAndSettle();
      expect(find.byType(LicensePage), findsOneWidget);
      expect(find.text('Établi Courrier'), findsWidgets);
      await capture('licenses');
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('More modules'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('feeds').last);
      await tester.pumpAndSettle();
      expect(find.text('courrier · feeds'), findsOneWidget);
      await tester.tap(find.text('courrier release notes'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Remove local feed'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(
        await tester.runAsync(() => db.select(db.feedSubscriptions).get()),
        hasLength(1),
      );
      await tester.tap(find.byTooltip('Remove local feed'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(
        await tester.runAsync(() => db.select(db.feedSubscriptions).get()),
        isEmpty,
      );
      // Drift retains closed query streams until a zero-delay timer fires.
      // Advance the widget fake clock while closing after route disposal.
      final closing = db.close();
      await tester.pump(const Duration(milliseconds: 1));
      await closing;
      closed = true;
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    },
  );
}

class _FileBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(await File(key).readAsBytes());
}
