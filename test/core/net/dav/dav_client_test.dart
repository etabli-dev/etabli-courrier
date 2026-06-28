import 'dart:io';

import 'package:courrier/core/net/dav/dav_client.dart';
import 'package:courrier/core/net/dav/discovery.dart';
import 'package:courrier/core/net/dav/sync_collection.dart';
import 'package:courrier/core/net/net_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String _load(String name) => File('test/fixtures/dav/$name').readAsStringSync();

DavClient _client(http.Client mock) => DavClient(
  credentials: const DavCredentials(
    username: 'courrier-test',
    password: 'app-password',
  ),
  httpClient: mock,
);

void main() {
  group('DavClient', () {
    test('PUT returns the etag from a successful create', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'PUT');
        expect(request.headers['if-none-match'], '*');
        expect(request.headers['authorization'], startsWith('Basic '));
        return http.Response('', 201, headers: {'etag': '"new-etag-1"'});
      });
      final result = await _client(mock).put(
        url: Uri.parse('https://cloud.example.org/path/new.ics'),
        body: 'BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n',
        contentType: 'text/calendar; charset=utf-8',
        ifNoneMatchAny: true,
      );
      expect(result.etag, '"new-etag-1"');
    });

    test('PUT surfaces 412 as PreconditionFailedError', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'PUT');
        expect(request.headers['if-match'], '"stale"');
        return http.Response('', 412, headers: {'etag': '"server-side"'});
      });
      expect(
        () => _client(mock).put(
          url: Uri.parse('https://cloud.example.org/path/abc.ics'),
          body: '',
          contentType: 'text/calendar',
          ifMatchEtag: '"stale"',
        ),
        throwsA(
          isA<PreconditionFailedError>().having(
            (e) => e.observedEtag,
            'observedEtag',
            '"server-side"',
          ),
        ),
      );
    });

    test('DELETE issues If-Match etag guard', () async {
      var seen = false;
      final mock = MockClient((http.Request request) async {
        seen = true;
        expect(request.method, 'DELETE');
        expect(request.headers['if-match'], '"e"');
        return http.Response('', 204);
      });
      await _client(mock).delete(
        url: Uri.parse('https://cloud.example.org/path/abc.ics'),
        ifMatchEtag: '"e"',
      );
      expect(seen, isTrue);
    });

    test('PROPFIND maps 401 to UnauthorizedError', () async {
      final mock = MockClient(
        (http.Request _) async => http.Response('nope', 401),
      );
      expect(
        () => _client(mock).propfind(
          url: Uri.parse('https://cloud.example.org/.well-known/caldav'),
          body: '<propfind/>',
        ),
        throwsA(isA<UnauthorizedError>()),
      );
    });
  });

  group('DavDiscovery', () {
    test('walks well-known → principal → home sets → enumeration', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'PROPFIND');
        final body = request.body;
        if (body.contains('current-user-principal')) {
          return http.Response(
            _load('principal_lookup.xml'),
            207,
            headers: {'content-type': 'application/xml'},
          );
        }
        if (body.contains('calendar-home-set')) {
          return http.Response(
            _load('home_sets.xml'),
            207,
            headers: {'content-type': 'application/xml'},
          );
        }
        if (body.contains('calendar-color')) {
          return http.Response(
            _load('calendar_enumeration.xml'),
            207,
            headers: {'content-type': 'application/xml'},
          );
        }
        return http.Response('', 404);
      });

      final discovery = DavDiscovery(
        client: _client(mock),
        baseUrl: Uri.parse('https://cloud.example.org'),
      );
      final result = await discovery.discover();

      expect(
        result.principalHref,
        '/remote.php/dav/principals/users/courrier-test/',
      );
      expect(
        result.calendarHomeHref,
        '/remote.php/dav/calendars/courrier-test/',
      );
      expect(
        result.addressbookHomeHref,
        '/remote.php/dav/addressbooks/users/courrier-test/',
      );
      expect(result.calendarCollections, hasLength(2));
    });
  });

  group('SyncCollectionClient', () {
    test('happy path returns changed + deleted + new sync-token', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'REPORT');
        expect(request.body.contains('http://sabre.io/ns/sync/42'), isTrue);
        return http.Response(
          _load('sync_collection_happy.xml'),
          207,
          headers: {'content-type': 'application/xml'},
        );
      });

      final result = await SyncCollectionClient(_client(mock)).run(
        collectionUrl: Uri.parse(
          'https://cloud.example.org/remote.php/dav/calendars/courrier-test/personal/',
        ),
        syncToken: 'http://sabre.io/ns/sync/42',
      );

      expect(result.changedHrefs, hasLength(2));
      expect(result.deletedHrefs, hasLength(1));
      expect(result.newSyncToken, 'http://sabre.io/ns/sync/43');
      expect(result.tokenWasReset, isFalse);
    });

    test(
      'stale sync-token (403) transparently retries with empty token',
      () async {
        var attempt = 0;
        final mock = MockClient((http.Request request) async {
          attempt += 1;
          if (attempt == 1) {
            expect(request.body.contains('stale-token'), isTrue);
            return http.Response('', 403);
          }
          // Second attempt MUST send an empty sync-token element.
          expect(request.body.contains('<D:sync-token/>'), isTrue);
          return http.Response(
            _load('sync_collection_reset.xml'),
            207,
            headers: {'content-type': 'application/xml'},
          );
        });

        final result = await SyncCollectionClient(_client(mock)).run(
          collectionUrl: Uri.parse(
            'https://cloud.example.org/remote.php/dav/calendars/courrier-test/personal/',
          ),
          syncToken: 'stale-token',
        );

        expect(attempt, 2);
        expect(result.tokenWasReset, isTrue);
        expect(result.newSyncToken, 'http://sabre.io/ns/sync/100');
        expect(result.changedHrefs, hasLength(1));
      },
    );
  });
}
