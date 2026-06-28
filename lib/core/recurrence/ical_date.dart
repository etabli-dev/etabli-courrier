// iCalendar date-time parsing (RFC 5545 §3.3.4 / §3.3.5).
//
// Three shapes:
//   * Date-only           — DTSTART;VALUE=DATE:20260620                 (all-day)
//   * Floating local      — DTSTART:20260620T100000                     (no Z, no TZID)
//   * UTC                 — DTSTART:20260620T100000Z                    (trailing Z)
//   * Local with TZID     — DTSTART;TZID=Europe/Berlin:20260620T100000
//
// We do NOT pull in a full IANA TZ database at M3 — DTSTART parsing returns
// the literal wall-clock time, plus a `tzid` string for downstream display.
// The audit dim 7 invariant is "round-trip preserves the original value
// verbatim", which is satisfied because the raw ICS is the source of truth.

import 'package:meta/meta.dart';

@immutable
class IcalDateTime {
  const IcalDateTime({
    required this.year,
    required this.month,
    required this.day,
    this.hour,
    this.minute,
    this.second,
    this.isAllDay = false,
    this.isUtc = false,
    this.tzid,
  });

  final int year;
  final int month;
  final int day;
  final int? hour;
  final int? minute;
  final int? second;
  final bool isAllDay;
  final bool isUtc;
  final String? tzid;

  /// Convert to a Dart [DateTime] for sorting and range queries. UTC values
  /// land at the correct UTC instant; floating-local / TZID values land at the
  /// host-local instant carrying the same wall-clock components (best the
  /// M3 layer can do without a TZ DB — the calendar UI still renders the
  /// original tzid label to the user).
  DateTime toDateTime() {
    if (isAllDay) {
      return DateTime(year, month, day);
    }
    if (isUtc) {
      return DateTime.utc(
        year,
        month,
        day,
        hour ?? 0,
        minute ?? 0,
        second ?? 0,
      );
    }
    return DateTime(year, month, day, hour ?? 0, minute ?? 0, second ?? 0);
  }
}

class IcalDateParser {
  const IcalDateParser();

  IcalDateTime parse(String raw, {String? valueParam, String? tzidParam}) {
    final value = raw.trim();
    if (valueParam == 'DATE' || value.length == 8) {
      return IcalDateTime(
        year: int.parse(value.substring(0, 4)),
        month: int.parse(value.substring(4, 6)),
        day: int.parse(value.substring(6, 8)),
        isAllDay: true,
      );
    }
    if (value.length < 15) {
      throw FormatException('Unexpected iCal date-time: "$raw"');
    }
    final year = int.parse(value.substring(0, 4));
    final month = int.parse(value.substring(4, 6));
    final day = int.parse(value.substring(6, 8));
    if (value[8] != 'T') {
      throw FormatException('Missing T separator: "$raw"');
    }
    final hour = int.parse(value.substring(9, 11));
    final minute = int.parse(value.substring(11, 13));
    final second = int.parse(value.substring(13, 15));
    final isUtc = value.endsWith('Z');
    return IcalDateTime(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      isUtc: isUtc,
      tzid: tzidParam,
    );
  }
}
