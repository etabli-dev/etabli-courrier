import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/net/dav/dav_client.dart' show DavCredentials;
import '../../../core/net/net_error.dart';

// Nextcloud News REST API client (v1-2):
//   /index.php/apps/news/api/v1-2/feeds
//   /index.php/apps/news/api/v1-2/items?batchSize=&offset=&getRead=&type=
//   /index.php/apps/news/api/v1-2/items/{id}/read
//   /index.php/apps/news/api/v1-2/items/{id}/unread
//
// Reference: https://github.com/nextcloud/news/blob/master/docs/api/api-v1-2.md

@immutable
class RemoteFeed {
  const RemoteFeed({
    required this.id,
    required this.url,
    required this.title,
    this.folder,
    this.lastUpdated,
  });

  factory RemoteFeed.fromJson(Map<String, dynamic> json) => RemoteFeed(
    id: (json['id'] as num).toInt(),
    url: json['url'] as String? ?? '',
    title: json['title'] as String? ?? '',
    folder: json['folderId'] == null
        ? null
        : (json['folderId'] as num).toString(),
    lastUpdated: json['lastUpdateError'] == null
        ? null
        : DateTime.now().toUtc(),
  );

  final int id;
  final String url;
  final String title;
  final String? folder;
  final DateTime? lastUpdated;
}

@immutable
class RemoteFeedItem {
  const RemoteFeedItem({
    required this.id,
    required this.feedId,
    required this.guidHash,
    required this.title,
    this.url,
    this.author,
    this.body,
    this.publishedAt,
    this.unread = false,
    this.starred = false,
  });

  factory RemoteFeedItem.fromJson(Map<String, dynamic> json) {
    final publishedSeconds = (json['pubDate'] as num?)?.toInt();
    return RemoteFeedItem(
      id: (json['id'] as num).toInt(),
      feedId: (json['feedId'] as num).toInt(),
      guidHash: json['guidHash'] as String? ?? '',
      title: json['title'] as String? ?? '',
      url: json['url'] as String?,
      author: json['author'] as String?,
      body: json['body'] as String?,
      publishedAt: publishedSeconds == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              publishedSeconds * 1000,
              isUtc: true,
            ),
      unread: json['unread'] as bool? ?? false,
      starred: json['starred'] as bool? ?? false,
    );
  }

  final int id;
  final int feedId;
  final String guidHash;
  final String title;
  final String? url;
  final String? author;
  final String? body;
  final DateTime? publishedAt;
  final bool unread;
  final bool starred;
}

class NextcloudNewsClient {
  NextcloudNewsClient({
    required this.baseUrl,
    required this.credentials,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final Uri baseUrl;
  final DavCredentials credentials;
  final http.Client _http;

  Uri _endpoint(String suffix) =>
      baseUrl.resolve('/index.php/apps/news/api/v1-2$suffix');

  Map<String, String> _headers() => {
    'authorization': credentials.basicAuthHeader,
    'accept': 'application/json',
  };

  Future<List<RemoteFeed>> listFeeds() async {
    final response = await _http.get(_endpoint('/feeds'), headers: _headers());
    _throwForStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['feeds'] as List<dynamic>? ?? const [];
    return list
        .map((f) => RemoteFeed.fromJson(f as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<List<RemoteFeedItem>> listItems({
    int batchSize = 100,
    int offset = 0,
    bool unreadOnly = false,
  }) async {
    final uri = _endpoint('/items').replace(
      queryParameters: {
        'batchSize': batchSize.toString(),
        'offset': offset.toString(),
        'type': '3', // 3 == all items
        'getRead': unreadOnly ? 'false' : 'true',
      },
    );
    final response = await _http.get(uri, headers: _headers());
    _throwForStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['items'] as List<dynamic>? ?? const [];
    return list
        .map((i) => RemoteFeedItem.fromJson(i as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> markRead(int itemId) async {
    final response = await _http.put(
      _endpoint('/items/$itemId/read'),
      headers: _headers(),
    );
    _throwForStatus(response);
  }

  Future<void> markUnread(int itemId) async {
    final response = await _http.put(
      _endpoint('/items/$itemId/unread'),
      headers: _headers(),
    );
    _throwForStatus(response);
  }

  void _throwForStatus(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) {
      return;
    }
    throw mapHttpStatus(code);
  }
}
