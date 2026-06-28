import 'package:courrier/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  testWidgets('Narrow viewport renders NavigationBar with seven destinations', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);

    await tester.pumpWidget(const CourrierApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

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
  });

  testWidgets('Wide viewport renders NavigationRail', (
    WidgetTester tester,
  ) async {
    _useWideView(tester);

    await tester.pumpWidget(const CourrierApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('Switching destinations renames the title', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);

    await tester.pumpWidget(const CourrierApp());
    await tester.pumpAndSettle();

    expect(find.text('courrier · mail'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_today_outlined).last);
    await tester.pumpAndSettle();

    expect(find.text('courrier · calendar'), findsOneWidget);
  });
}
