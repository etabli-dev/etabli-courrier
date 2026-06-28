// Sealed error model. Every network-aware repo returns one of these on failure
// so the UI and the sync engine can route uniformly.
//
// Mapping reference:
//   * offline             — IO failure / no route to host / DNS failure / socket closed pre-handshake.
//   * unauthorized        — HTTP 401 / IMAP NO BAD on auth / SMTP 535.
//   * forbidden           — HTTP 403 / IMAP NO with permission text.
//   * notFound            — HTTP 404 / no such mailbox / DAV report no resource.
//   * preconditionFailed  — HTTP 412 (etag mismatch on PUT/DELETE) → triggers the conflict path.
//   * conflict            — HTTP 409 / DAV report state divergence we can't reconcile silently.
//   * throttled           — HTTP 429 / 503 with Retry-After / IMAP SERVERBUG bounce.
//   * serverError         — HTTP 5xx other than throttled.
//   * parseFailure        — malformed XML/MIME/iCal/vCard from a remote we trust to be well-formed.
//   * unknown             — caught-but-not-classified. Always logged.

import 'package:meta/meta.dart';

@immutable
sealed class NetError implements Exception {
  const NetError(this.message, {this.cause, this.statusCode});

  final String message;
  final Object? cause;
  final int? statusCode;

  // Subtypes set this to a static label so toString() avoids runtimeType
  // (which is unsafe in release with tree-shaking — lint: no_runtimeType_toString).
  String get kind;

  @override
  String toString() => '$kind($message, status=$statusCode)';
}

class OfflineError extends NetError {
  const OfflineError({super.cause}) : super('offline');
  @override
  String get kind => 'OfflineError';
}

class UnauthorizedError extends NetError {
  const UnauthorizedError({super.cause, super.statusCode = 401})
    : super('unauthorized');
  @override
  String get kind => 'UnauthorizedError';
}

class ForbiddenError extends NetError {
  const ForbiddenError({super.cause, super.statusCode = 403})
    : super('forbidden');
  @override
  String get kind => 'ForbiddenError';
}

class NotFoundError extends NetError {
  const NotFoundError({super.cause, super.statusCode = 404})
    : super('not found');
  @override
  String get kind => 'NotFoundError';
}

class PreconditionFailedError extends NetError {
  const PreconditionFailedError({this.observedEtag, super.cause})
    : super('etag mismatch', statusCode: 412);

  final String? observedEtag;
  @override
  String get kind => 'PreconditionFailedError';
}

class ConflictError extends NetError {
  const ConflictError({super.cause, super.statusCode = 409})
    : super('conflict');
  @override
  String get kind => 'ConflictError';
}

class ThrottledError extends NetError {
  const ThrottledError({this.retryAfter, super.cause, super.statusCode})
    : super('throttled');

  final Duration? retryAfter;
  @override
  String get kind => 'ThrottledError';
}

class ServerError extends NetError {
  const ServerError({super.cause, required int super.statusCode})
    : super('server error');
  @override
  String get kind => 'ServerError';
}

class ParseFailureError extends NetError {
  const ParseFailureError(String detail, {super.cause})
    : super('parse failure: $detail');
  @override
  String get kind => 'ParseFailureError';
}

class UnknownNetError extends NetError {
  const UnknownNetError({super.cause, super.statusCode})
    : super('unknown network error');
  @override
  String get kind => 'UnknownNetError';
}

NetError mapHttpStatus(int code, {Object? cause}) {
  if (code == 401) {
    return UnauthorizedError(cause: cause);
  }
  if (code == 403) {
    return ForbiddenError(cause: cause);
  }
  if (code == 404) {
    return NotFoundError(cause: cause);
  }
  if (code == 409) {
    return ConflictError(cause: cause);
  }
  if (code == 412) {
    return PreconditionFailedError(cause: cause);
  }
  if (code == 429) {
    return ThrottledError(cause: cause, statusCode: code);
  }
  if (code >= 500 && code < 600) {
    if (code == 503) {
      return ThrottledError(cause: cause, statusCode: code);
    }
    return ServerError(cause: cause, statusCode: code);
  }
  return UnknownNetError(cause: cause, statusCode: code);
}
