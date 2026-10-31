import 'package:courrier/core/db/database.dart';
import 'package:courrier/main.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _useNarrowView(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void _useWideView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1200, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  late CourrierDatabase db;
  var closed = false;
  setUp(() {
    closed = false;
    db = CourrierDatabase.forTesting(NativeDatabase.memory());
  });
  tearDown(() async {
    if (!closed) await db.close();
  });
  testWidgets(
    'Phone navigation keeps all seven modules reachable with readable labels',
    (WidgetTester tester) async {
      _useNarrowView(tester);

      await tester.pumpWidget(CourrierApp(database: db));
      await tester.pumpAndSettle();
      await tester.pumpAndSettle();

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).destinations,
        hasLength(5),
      );
      await tester.tap(find.byTooltip('More modules'));
      await tester.pumpAndSettle();

      for (final label in [
        'mail',
        'calendar',
        'contacts',
        'tasks',
        'reminders',
        'notes',
        'feeds',
      ]) {
        expect(find.text(label), findsWidgets, reason: 'missing $label');
      }
      await db.close();
      closed = true;
    },
  );

  testWidgets('Wide viewport renders NavigationRail', (
    WidgetTester tester,
  ) async {
    _useWideView(tester);

    await tester.pumpWidget(CourrierApp(database: db));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    await db.close();
    closed = true;
  });

  testWidgets('Switching destinations renames the title', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);

    await tester.pumpWidget(CourrierApp(database: db));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();

    expect(find.text('courrier · mail'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today_outlined).last);
    await tester.pumpAndSettle();

    expect(find.text('courrier · calendar'), findsOneWidget);
    await db.close();
    closed = true;
  });
}
