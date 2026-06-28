import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/theme/app_theme.dart';
import 'package:courrier/modules/calendar/ui/agenda_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarEvent _event({
  required int id,
  required String summary,
  required DateTime dtstart,
  String? rrule,
  String? location,
}) => CalendarEvent(
  id: id,
  collectionId: 1,
  uid: 'uid-$id',
  summary: summary,
  location: location,
  dtstart: dtstart,
  dtend: dtstart.add(const Duration(hours: 1)),
  allDay: false,
  rrule: rrule,
  rawIcs: '',
  lastModified: DateTime.utc(2026, 6, 27),
  deletedLocally: false,
);

void main() {
  testWidgets('AgendaView renders empty state when no events', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(body: AgendaView(events: const [])),
      ),
    );
    expect(find.textContaining('No events'), findsOneWidget);
  });

  testWidgets(
    'AgendaView renders one tile per event with title + recurrence label',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(420, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final events = [
        _event(
          id: 1,
          summary: 'Standup',
          dtstart: DateTime.utc(2026, 6, 22, 10),
          rrule: 'FREQ=WEEKLY;BYDAY=MO',
        ),
        _event(
          id: 2,
          summary: 'Quarterly review',
          dtstart: DateTime.utc(2026, 6, 25, 14),
          location: 'Room 314',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CourrierTheme.light(),
          home: Scaffold(body: AgendaView(events: events)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Standup'), findsOneWidget);
      expect(find.text('Quarterly review'), findsOneWidget);
      // Recurrence label produced by RruleFormatter.
      expect(find.textContaining('Weekly on Monday'), findsOneWidget);
      // Location surfaced on the second tile.
      expect(find.text('Room 314'), findsOneWidget);
    },
  );

  testWidgets('AgendaView taps invoke onEventTap', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    CalendarEvent? tapped;
    final events = [
      _event(
        id: 1,
        summary: 'Tappable',
        dtstart: DateTime.utc(2026, 6, 22, 10),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(
          body: AgendaView(events: events, onEventTap: (e) => tapped = e),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tappable'));
    expect(tapped?.summary, 'Tappable');
  });
}
