import 'dart:convert';

import 'package:courrier/core/net/dav/dav_client.dart';
import 'package:courrier/core/net/net_error.dart';
import 'package:courrier/modules/notes/sync/nextcloud_notes_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

NextcloudNotesClient _client(http.Client mock) => NextcloudNotesClient(
  baseUrl: Uri.parse('https://cloud.example.org'),
  credentials: const DavCredentials(username: 'user', password: 'app-password'),
  httpClient: mock,
);

void main() {
  group('listNotes', () {
    test('decodes the Notes REST JSON list with optional fields', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/index.php/apps/notes/api/v1/notes');
        expect(request.headers['authorization'], startsWith('Basic '));
        return http.Response(
          jsonEncode([
            {
              'id': 1,
              'title': 'Shopping',
              'content': '- [ ] milk\n- [x] eggs',
              'category': 'Personal',
              'favorite': true,
              'modified': 1700000000,
              'etag': '"abc"',
            },
            {
              'id': 2,
              'title': 'Snippet',
              'content': 'one-liner',
              'modified': 1700001000,
            },
          ]),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final notes = await _client(mock).listNotes();
      expect(notes, hasLength(2));
      expect(notes.first.title, 'Shopping');
      expect(notes.first.favorite, isTrue);
      expect(notes.first.etag, '"abc"');
      expect(notes.last.favorite, isFalse);
    });
  });

  group('createNote', () {
    test('POSTs JSON + returns parsed RemoteNote', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'POST');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['title'], 'New');
        expect(body['content'], 'Body');
        return http.Response(
          jsonEncode({
            'id': 99,
            'title': 'New',
            'content': 'Body',
            'modified': 1700000000,
            'etag': '"server-etag"',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final note = await _client(
        mock,
      ).createNote(title: 'New', content: 'Body');
      expect(note.id, 99);
      expect(note.etag, '"server-etag"');
    });
  });

  group('updateNote', () {
    test('PUT carries If-Match etag + returns rotated etag', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/index.php/apps/notes/api/v1/notes/7');
        expect(request.headers['if-match'], '"v1"');
        return http.Response(
          jsonEncode({
            'id': 7,
            'title': 'Updated',
            'content': '',
            'modified': 1700000000,
            'etag': '"v2"',
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final updated = await _client(
        mock,
      ).updateNote(id: 7, title: 'Updated', content: '', ifMatchEtag: '"v1"');
      expect(updated.etag, '"v2"');
    });

    test('PUT 412 → PreconditionFailedError carrying server etag', () async {
      final mock = MockClient(
        (http.Request _) async =>
            http.Response('', 412, headers: {'etag': '"server-side"'}),
      );
      expect(
        () => _client(
          mock,
        ).updateNote(id: 7, title: 't', content: 'c', ifMatchEtag: '"stale"'),
        throwsA(
          isA<PreconditionFailedError>().having(
            (e) => e.observedEtag,
            'observedEtag',
            '"server-side"',
          ),
        ),
      );
    });
  });

  group('deleteNote', () {
    test('DELETE carries If-Match', () async {
      var hit = false;
      final mock = MockClient((http.Request request) async {
        hit = true;
        expect(request.method, 'DELETE');
        expect(request.headers['if-match'], '"v1"');
        return http.Response('', 204);
      });
      await _client(mock).deleteNote(id: 7, ifMatchEtag: '"v1"');
      expect(hit, isTrue);
    });
  });
}
