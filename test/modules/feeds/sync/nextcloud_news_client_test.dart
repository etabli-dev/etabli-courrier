import 'dart:convert';

import 'package:courrier/core/net/dav/dav_client.dart';
import 'package:courrier/modules/feeds/sync/nextcloud_news_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

NextcloudNewsClient _client(http.Client mock) => NextcloudNewsClient(
  baseUrl: Uri.parse('https://cloud.example.org'),
  credentials: const DavCredentials(username: 'user', password: 'app-password'),
  httpClient: mock,
);

void main() {
  group('NextcloudNewsClient', () {
    test('listFeeds decodes the v1-2 feeds envelope', () async {
      final mock = MockClient((http.Request request) async {
        expect(request.url.path, '/index.php/apps/news/api/v1-2/feeds');
        expect(request.headers['authorization'], startsWith('Basic '));
        return http.Response(
          jsonEncode({
            'feeds': [
              {
                'id': 1,
                'url': 'https://example.org/rss',
                'title': 'Example',
                'folderId': 2,
              },
              {
                'id': 2,
                'url': 'https://another.example/atom',
                'title': 'Another',
              },
            ],
            'starredCount': 0,
            'newestItemId': 100,
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final feeds = await _client(mock).listFeeds();
      expect(feeds, hasLength(2));
      expect(feeds.first.id, 1);
      expect(feeds.first.title, 'Example');
      expect(feeds.first.folder, '2');
      expect(feeds.last.folder, isNull);
    });

    test('listItems passes batchSize + offset + getRead', () async {
      final mock = MockClient((http.Request request) async {
        final q = request.url.queryParameters;
        expect(q['batchSize'], '50');
        expect(q['offset'], '0');
        expect(q['type'], '3');
        expect(q['getRead'], 'false');
        return http.Response(
          jsonEncode({
            'items': [
              {
                'id': 10,
                'feedId': 1,
                'guidHash': 'g10',
                'title': 'First',
                'url': 'https://example.org/first',
                'author': 'A',
                'body': '<p>hi</p>',
                'pubDate': 1707903000,
                'unread': true,
                'starred': false,
              },
            ],
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final items = await _client(
        mock,
      ).listItems(batchSize: 50, unreadOnly: true);
      expect(items, hasLength(1));
      expect(items.first.title, 'First');
      expect(items.first.unread, isTrue);
      expect(
        items.first.publishedAt,
        DateTime.fromMillisecondsSinceEpoch(1707903000 * 1000, isUtc: true),
      );
    });

    test('markRead PUTs to /items/{id}/read', () async {
      var hit = false;
      final mock = MockClient((http.Request request) async {
        hit = true;
        expect(request.method, 'PUT');
        expect(request.url.path, '/index.php/apps/news/api/v1-2/items/10/read');
        return http.Response('', 200);
      });
      await _client(mock).markRead(10);
      expect(hit, isTrue);
    });
  });
}
