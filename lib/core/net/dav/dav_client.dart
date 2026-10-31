import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../bounded_http.dart';
import '../net_error.dart';
import 'multistatus.dart';

// Thin DAV HTTP wrapper. Sends PROPFIND / REPORT / PUT / DELETE, maps every
// non-2xx into a NetError, and parses multistatus bodies.
//
// Nuage-reusable: this class knows nothing about `courrier`; it operates on
// generic URIs and credentials. Reuse from any Établi suite app that speaks DAV.

@immutable
class DavCredentials {
  const DavCredentials({required this.username, required this.password});

  final String username;
  final String password;

  String get basicAuthHeader =>
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
}

class DavClient {
  DavClient({required this.credentials, http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  final DavCredentials credentials;
  final http.Client _http;
  Uri? _origin;

  Uri _checked(Uri uri) {
    requireHttps(uri);
    final origin = _origin ??= uri;
    return sameOrigin(origin, uri.toString());
  }

  Future<http.Response> get({required Uri url}) async {
    final response = await boundedRequest(
      _http,
      'GET',
      _checked(url),
      headers: {'authorization': credentials.basicAuthHeader},
    );
    _throwForStatus(response);
    return response;
  }

  /// PROPFIND with explicit Depth + body.
  Future<Multistatus> propfind({
    required Uri url,
    required String body,
    String depth = '0',
  }) async {
    final response = await _send(
      method: 'PROPFIND',
      url: url,
      body: body,
      depth: depth,
      contentType: 'application/xml; charset=utf-8',
    );
    return Multistatus.parse(response.body);
  }

  /// REPORT (sync-collection, calendar-multiget, addressbook-multiget, …).
  /// Returns the parsed multistatus along with the raw body so callers that
  /// need a top-level `<sync-token>` can pull it themselves.
  Future<DavReportResult> report({
    required Uri url,
    required String body,
    String depth = '1',
  }) async {
    final response = await _send(
      method: 'REPORT',
      url: url,
      body: body,
      depth: depth,
      contentType: 'application/xml; charset=utf-8',
    );
    return DavReportResult(
      multistatus: Multistatus.parse(response.body),
      rawBody: response.body,
    );
  }

  /// PUT with If-Match (update) or If-None-Match: * (create). Returns the new
  /// etag from the response if the server provided one.
  Future<DavPutResult> put({
    required Uri url,
    required String body,
    required String contentType,
    String? ifMatchEtag,
    bool ifNoneMatchAny = false,
  }) async {
    final headers = <String, String>{
      'authorization': credentials.basicAuthHeader,
      'content-type': contentType,
    };
    if (ifMatchEtag != null) {
      headers['if-match'] = ifMatchEtag;
    } else if (ifNoneMatchAny) {
      headers['if-none-match'] = '*';
    }
    final response = await boundedRequest(
      _http,
      'PUT',
      _checked(url),
      headers: headers,
      body: body,
    );
    _throwForStatus(response);
    return DavPutResult(etag: response.headers['etag']);
  }

  /// DELETE with optional etag guard.
  Future<void> delete({required Uri url, String? ifMatchEtag}) async {
    final headers = <String, String>{
      'authorization': credentials.basicAuthHeader,
    };
    if (ifMatchEtag != null) {
      headers['if-match'] = ifMatchEtag;
    }
    final response = await boundedRequest(
      _http,
      'DELETE',
      _checked(url),
      headers: headers,
    );
    _throwForStatus(response);
  }

  Future<http.Response> _send({
    required String method,
    required Uri url,
    required String body,
    required String depth,
    required String contentType,
  }) async {
    var target = _checked(url);
    for (var redirects = 0; redirects <= 5; redirects++) {
      final response = await boundedRequest(
        _http,
        method,
        target,
        body: body,
        headers: {
          'authorization': credentials.basicAuthHeader,
          'content-type': contentType,
          'depth': depth,
        },
      );
      if (method == 'PROPFIND' &&
          [301, 302, 307, 308].contains(response.statusCode)) {
        final location = response.headers['location'];
        if (location == null) {
          throw const ParseFailureError('redirect without a location');
        }
        target = _checked(target.resolve(location));
        continue;
      }
      _throwForStatus(response);
      return response;
    }
    throw const ParseFailureError('too many DAV redirects');
  }

  void _throwForStatus(http.Response response) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) {
      return;
    }
    // Multi-Status (207) is success — only PROPFIND/REPORT reach here.
    if (code == 207) {
      return;
    }
    if (code == 403 && response.body.contains('valid-sync-token')) {
      throw const InvalidSyncTokenError();
    }
    if (code == 412) {
      throw PreconditionFailedError(observedEtag: response.headers['etag']);
    }
    throw mapHttpStatus(code);
  }

  Future<void> close() async => _http.close();
}

@immutable
class DavReportResult {
  const DavReportResult({required this.multistatus, required this.rawBody});

  final Multistatus multistatus;
  final String rawBody;
}

@immutable
class DavPutResult {
  const DavPutResult({this.etag});
  final String? etag;
}

class InvalidSyncTokenError extends ForbiddenError {
  const InvalidSyncTokenError();
}
