import 'package:courrier/modules/calendar/ui/recurrence_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RecurrenceDeleteDialog returns thisOccurrence', (tester) async {
    RecurrenceDeleteScope? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                picked = await RecurrenceDeleteDialog.show(context);
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('This occurrence only'));
    await tester.pumpAndSettle();

    expect(picked, RecurrenceDeleteScope.thisOccurrence);
  });

  testWidgets('RecurrenceDeleteDialog returns thisAndFollowing', (
    tester,
  ) async {
    RecurrenceDeleteScope? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                picked = await RecurrenceDeleteDialog.show(context);
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('This and following occurrences'));
    await tester.pumpAndSettle();

    expect(picked, RecurrenceDeleteScope.thisAndFollowing);
  });

  testWidgets('RecurrenceDeleteDialog returns all', (tester) async {
    RecurrenceDeleteScope? picked;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                picked = await RecurrenceDeleteDialog.show(context);
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('All occurrences'));
    await tester.pumpAndSettle();

    expect(picked, RecurrenceDeleteScope.all);
  });
}
