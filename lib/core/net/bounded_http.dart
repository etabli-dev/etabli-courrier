import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'net_error.dart';

Uri requireHttps(Uri uri) {
  if (uri.scheme != 'https' ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasFragment) {
    throw const FormatException(
      'Use an HTTPS URL without embedded credentials or a fragment.',
    );
  }
  return uri;
}

Uri serverBase(String value) {
  final uri = requireHttps(Uri.parse(value.trim()));
  if (uri.hasQuery) {
    throw const FormatException('The server base URL cannot contain a query.');
  }
  return uri.replace(path: uri.path.endsWith('/') ? uri.path : '${uri.path}/');
}

Uri sameOrigin(Uri base, String href) {
  final target = requireHttps(base.resolve(href));
  if (target.origin != base.origin) {
    throw const FormatException('The server returned a different origin.');
  }
  return target;
}

/// Bounds the entire response, including stalled bodies. Closing the owned
/// client on failure cancels the transfer; callers create another session to retry.
Future<http.Response> boundedRequest(
  http.Client client,
  String method,
  Uri uri, {
  Map<String, String> headers = const {},
  String? body,
  int maxBytes = 8 * 1024 * 1024,
  Duration timeout = const Duration(seconds: 30),
}) async {
  requireHttps(uri);
  Future<http.Response> transfer() async {
    final request = http.Request(method, uri)..followRedirects = false;
    request.headers.addAll(headers);
    if (body != null) request.body = body;
    final response = await client.send(request);
    if ((response.contentLength ?? 0) > maxBytes) {
      throw const ParseFailureError('response exceeds the size limit');
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in response.stream) {
      if (bytes.length + chunk.length > maxBytes) {
        throw const ParseFailureError('response exceeds the size limit');
      }
      bytes.add(chunk);
    }
    return http.Response.bytes(
      bytes.takeBytes(),
      response.statusCode,
      headers: response.headers,
      request: request,
    );
  }

  try {
    return await transfer().timeout(timeout);
  } on TimeoutException catch (error) {
    client.close();
    throw OfflineError(cause: error);
  } on SocketException catch (error) {
    client.close();
    throw OfflineError(cause: error);
  } on http.ClientException catch (error) {
    client.close();
    throw OfflineError(cause: error);
  } on Exception {
    client.close();
    rethrow;
  }
}

/// REST clients share the same transport limits and never forward credentials
/// through redirects or server-provided foreign URLs.
class BoundedClient extends http.BaseClient {
  BoundedClient({required this.origin, http.Client? client})
    : _client = client ?? http.Client();
  final Uri origin;
  final http.Client _client;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final target = sameOrigin(origin, request.url.toString());
    if (request is! http.Request) {
      throw const FormatException(
        'Streaming request bodies are not supported.',
      );
    }
    final response = await boundedRequest(
      _client,
      request.method,
      target,
      headers: request.headers,
      body: request.body,
    );
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      contentLength: response.bodyBytes.length,
      request: request,
    );
  }

  @override
  void close() => _client.close();
}
