import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../../../core/net/dav/dav_client.dart' show DavCredentials;
import '../../../core/net/net_error.dart';

// Thin Nextcloud Notes REST client (https://github.com/nextcloud/notes).
//
// Endpoints (v1):
//   GET  /index.php/apps/notes/api/v1/notes
//   GET  /index.php/apps/notes/api/v1/notes/{id}
//   POST /index.php/apps/notes/api/v1/notes
//   PUT  /index.php/apps/notes/api/v1/notes/{id}
//   DELETE /index.php/apps/notes/api/v1/notes/{id}
//
// We only model the fields the M9 schema uses; unknown JSON fields are
// preserved on the in-memory representation so a re-PUT stays round-trippable.

@immutable
class RemoteNote {
  const RemoteNote({
    required this.id,
    required this.title,
    required this.content,
    required this.modified,
    this.category,
    this.favorite = false,
    this.etag,
  });

  factory RemoteNote.fromJson(Map<String, dynamic> json) {
    final modifiedSeconds = (json['modified'] as num?)?.toInt();
    return RemoteNote(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      category: json['category'] as String?,
      favorite: json['favorite'] as bool? ?? false,
      etag: json['etag'] as String?,
      modified: modifiedSeconds == null
          ? DateTime.now().toUtc()
          : DateTime.fromMillisecondsSinceEpoch(
              modifiedSeconds * 1000,
              isUtc: true,
            ),
    );
  }

  final int id;
  final String title;
  final String content;
  final String? category;
  final bool favorite;
  final String? etag;
  final DateTime modified;
}

class NextcloudNotesClient {
  NextcloudNotesClient({
    required this.baseUrl,
    required this.credentials,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final Uri baseUrl;
  final DavCredentials credentials;
  final http.Client _http;

  Uri _endpoint([String suffix = '']) =>
      baseUrl.resolve('/index.php/apps/notes/api/v1/notes$suffix');

  Map<String, String> _headers({String? ifMatchEtag}) => {
    'authorization': credentials.basicAuthHeader,
    'accept': 'application/json',
    'if-match': ?ifMatchEtag,
  };

  Future<List<RemoteNote>> listNotes() async {
    final response = await _http.get(_endpoint(), headers: _headers());
    _throwForStatus(response);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => RemoteNote.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<RemoteNote> createNote({
    required String title,
    required String content,
    String? category,
    bool favorite = false,
  }) async {
    final response = await _http.post(
      _endpoint(),
      headers: {..._headers(), 'content-type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': ?category,
        'favorite': favorite,
      }),
    );
    _throwForStatus(response);
    return RemoteNote.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<RemoteNote> updateNote({
    required int id,
    required String title,
    required String content,
    String? category,
    bool favorite = false,
    String? ifMatchEtag,
  }) async {
    final response = await _http.put(
      _endpoint('/$id'),
      headers: {
        ..._headers(ifMatchEtag: ifMatchEtag),
        'content-type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': ?category,
        'favorite': favorite,
      }),
    );
    _throwForStatus(response);
    return RemoteNote.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> deleteNote({required int id, String? ifMatchEtag}) async {
    final response = await _http.delete(
      _endpoint('/$id'),
      headers: _headers(ifMatchEtag: ifMatchEtag),
    );
    _throwForStatus(response);
  }

  void _throwForStatus(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) {
      return;
    }
    if (code == 412) {
      throw PreconditionFailedError(observedEtag: response.headers['etag']);
    }
    throw mapHttpStatus(code);
  }
}
