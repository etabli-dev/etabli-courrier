import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/theme/app_theme.dart';
import 'package:courrier/modules/contacts/ui/contacts_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ContactCard _card({
  required int id,
  required String fn,
  String? org,
  String? email,
}) => ContactCard(
  id: id,
  collectionId: 1,
  uid: 'uid-$id',
  formattedName: fn,
  organization: org,
  primaryEmail: email,
  rawVcard: 'BEGIN:VCARD\r\nVERSION:4.0\r\nFN:$fn\r\nEND:VCARD\r\n',
  lastModified: DateTime.utc(2026, 6, 28),
  deletedLocally: false,
);

void main() {
  testWidgets('Renders empty state when no contacts', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: const Scaffold(body: ContactsListView(contacts: [])),
      ),
    );
    expect(find.textContaining('No contacts'), findsOneWidget);
  });

  testWidgets('Renders one tile per contact with org + email subtitles', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final contacts = [
      _card(
        id: 1,
        fn: 'Ada Lovelace',
        org: 'Analytical Engines',
        email: 'ada@example.org',
      ),
      _card(id: 2, fn: 'Bob Brown'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(body: ContactsListView(contacts: contacts)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Analytical Engines'), findsOneWidget);
    expect(find.text('ada@example.org'), findsOneWidget);
    expect(find.text('Bob Brown'), findsOneWidget);
  });

  testWidgets('Taps invoke onContactTap', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    ContactCard? tapped;
    final contacts = [_card(id: 1, fn: 'Tappable')];
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(
          body: ContactsListView(
            contacts: contacts,
            onContactTap: (c) => tapped = c,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tappable'));
    expect(tapped?.formattedName, 'Tappable');
  });
}
