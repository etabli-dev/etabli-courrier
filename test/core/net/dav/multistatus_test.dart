import 'dart:io';

import 'package:courrier/core/net/dav/multistatus.dart';
import 'package:flutter_test/flutter_test.dart';

String _load(String name) => File('test/fixtures/dav/$name').readAsStringSync();

void main() {
  group('Multistatus parsing', () {
    test('current-user-principal href extracted', () {
      final ms = Multistatus.parse(_load('principal_lookup.xml'));
      expect(ms.resources, hasLength(1));
      expect(
        ms.resources.first.currentUserPrincipal,
        '/remote.php/dav/principals/users/courrier-test/',
      );
    });

    test('home sets extracted', () {
      final ms = Multistatus.parse(_load('home_sets.xml'));
      final r = ms.resources.first;
      expect(r.calendarHomeSet, '/remote.php/dav/calendars/courrier-test/');
      expect(
        r.addressbookHomeSet,
        '/remote.php/dav/addressbooks/users/courrier-test/',
      );
    });

    test('calendar enumeration captures all named properties', () {
      final ms = Multistatus.parse(_load('calendar_enumeration.xml'));
      final calendars = ms.resources.where((r) => r.isCalendar).toList();
      expect(calendars, hasLength(2));

      final personal = calendars.firstWhere(
        (r) => r.href.endsWith('/personal/'),
      );
      expect(personal.displayName, 'Personal');
      expect(personal.ctag, 'http://sabre.io/ns/sync/42');
      expect(personal.syncToken, 'http://sabre.io/ns/sync/42');
      expect(personal.calendarColor, '#28a745ff');
      expect(personal.calendarOrder, '1');
      expect(personal.supportedCalendarComponentSet, 'VEVENT,VTODO');
    });

    test(
      'sync-collection extracts top-level sync-token + changed + deleted',
      () {
        final body = _load('sync_collection_happy.xml');
        final ms = Multistatus.parse(body);
        expect(ms.resources, hasLength(3));

        final changed = ms.resources
            .where((r) => r.properties.isNotEmpty)
            .toList();
        final deleted = ms.resources
            .where((r) => r.properties.isEmpty)
            .toList();
        expect(changed, hasLength(2));
        expect(deleted, hasLength(1));
        expect(deleted.single.href.endsWith('gone.ics'), isTrue);

        expect(
          Multistatus.extractSyncToken(body),
          'http://sabre.io/ns/sync/43',
        );
      },
    );
  });
}
