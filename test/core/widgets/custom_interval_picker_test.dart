import 'package:courrier/core/theme/app_theme.dart';
import 'package:courrier/core/widgets/custom_interval_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Normalises 1440 minutes to 1 day on first render', (
    tester,
  ) async {
    int? captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(
          body: CustomIntervalPicker(
            initialMinutes: 1440,
            onChanged: (m) => captured = m,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    // Switching to minutes should emit 1 minute, then back to days emits 1440.
    await tester.tap(find.text('min'));
    await tester.pumpAndSettle();
    expect(captured, 1);

    await tester.tap(find.text('day'));
    await tester.pumpAndSettle();
    expect(captured, 1440);
  });

  testWidgets('Hours unit converts amount to minutes', (tester) async {
    int? captured;
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(
          body: CustomIntervalPicker(
            initialMinutes: 60,
            onChanged: (m) => captured = m,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '6');
    await tester.pumpAndSettle();
    expect(captured, 6 * 60);
  });
}
