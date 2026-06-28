import 'package:courrier/core/net/net_error.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapHttpStatus', () {
    test('401 → UnauthorizedError', () {
      expect(mapHttpStatus(401), isA<UnauthorizedError>());
    });
    test('403 → ForbiddenError', () {
      expect(mapHttpStatus(403), isA<ForbiddenError>());
    });
    test('404 → NotFoundError', () {
      expect(mapHttpStatus(404), isA<NotFoundError>());
    });
    test('409 → ConflictError', () {
      expect(mapHttpStatus(409), isA<ConflictError>());
    });
    test('412 → PreconditionFailedError (etag mismatch path)', () {
      final err = mapHttpStatus(412);
      expect(err, isA<PreconditionFailedError>());
      expect(err.statusCode, 412);
    });
    test('429 → ThrottledError', () {
      expect(mapHttpStatus(429), isA<ThrottledError>());
    });
    test('500 → ServerError', () {
      expect(mapHttpStatus(500), isA<ServerError>());
    });
    test('503 → ThrottledError (Retry-After path)', () {
      expect(mapHttpStatus(503), isA<ThrottledError>());
    });
    test('418 (uncategorised) → UnknownNetError', () {
      expect(mapHttpStatus(418), isA<UnknownNetError>());
    });
  });
}
