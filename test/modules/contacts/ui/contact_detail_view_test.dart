import 'dart:io';

import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/theme/app_theme.dart';
import 'package:courrier/modules/contacts/ui/contact_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Detail surfaces emails + phones + addresses from rawVcard', (
    tester,
  ) async {
    final source = File('test/fixtures/ical/vcard_full.vcf').readAsStringSync();
    final card = ContactCard(
      id: 1,
      collectionId: 1,
      uid: 'vcard-uid-001',
      formattedName: 'Ada Lovelace',
      organization: 'Analytical Engines',
      rawVcard: source,
      lastModified: DateTime.utc(2026, 6, 28),
      deletedLocally: false,
    );

    await tester.binding.setSurfaceSize(const Size(420, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(body: ContactDetailView(contact: card)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Analytical Engines'), findsOneWidget);
    expect(find.text('ada@example.org'), findsOneWidget);
    expect(find.text('lovelace@example.net'), findsOneWidget);
    expect(find.text('+44-20-7000-1815'), findsOneWidget);
  });
}
