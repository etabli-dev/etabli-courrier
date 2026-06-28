import 'package:courrier/core/recurrence/ical_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const parser = IcalDateParser();

  group('IcalDateParser', () {
    test('parses VALUE=DATE → all-day', () {
      final d = parser.parse('20260620', valueParam: 'DATE');
      expect(d.isAllDay, isTrue);
      expect(d.year, 2026);
      expect(d.month, 6);
      expect(d.day, 20);
    });

    test('parses bare 8-char value as DATE-only (lenient)', () {
      final d = parser.parse('20260620');
      expect(d.isAllDay, isTrue);
    });

    test('parses UTC date-time with Z suffix', () {
      final d = parser.parse('20260620T100000Z');
      expect(d.isUtc, isTrue);
      expect(d.hour, 10);
      expect(d.toDateTime(), DateTime.utc(2026, 6, 20, 10));
    });

    test('parses TZID local date-time and preserves the tzid', () {
      final d = parser.parse('20260620T100000', tzidParam: 'Europe/Berlin');
      expect(d.isUtc, isFalse);
      expect(d.tzid, 'Europe/Berlin');
      expect(d.hour, 10);
    });

    test(
      'DST edge: 30 Mar 2026 02:30 in Europe/Berlin parses without throwing',
      () {
        // Sunday 29 Mar 2026 02:00 → 03:00 in Berlin (CET → CEST).
        // We don't yet apply a TZ DB, but the value must survive parse.
        final d = parser.parse('20260329T023000', tzidParam: 'Europe/Berlin');
        expect(d.tzid, 'Europe/Berlin');
        expect(d.hour, 2);
        expect(d.minute, 30);
      },
    );

    test('throws on malformed input', () {
      expect(() => parser.parse('2026'), throwsA(isA<FormatException>()));
    });
  });
}
