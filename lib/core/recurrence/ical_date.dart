// iCalendar date-time parsing (RFC 5545 §3.3.4 / §3.3.5).
//
// Three shapes:
//   * Date-only           — DTSTART;VALUE=DATE:20260620                 (all-day)
//   * Floating local      — DTSTART:20260620T100000                     (no Z, no TZID)
//   * UTC                 — DTSTART:20260620T100000Z                    (trailing Z)
//   * Local with TZID     — DTSTART;TZID=Europe/Berlin:20260620T100000
//
// IANA TZID values resolve to their actual instant. Original ICS remains intact.

import 'package:meta/meta.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

bool _zonesReady = false;

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

  /// Resolve UTC and IANA TZID values; floating values use the device local zone.
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
    if (tzid != null && tzid!.isNotEmpty) {
      if (!_zonesReady) {
        tzdata.initializeTimeZones();
        _zonesReady = true;
      }
      try {
        return tz.TZDateTime(
          tz.getLocation(tzid!),
          year,
          month,
          day,
          hour ?? 0,
          minute ?? 0,
          second ?? 0,
        );
      } on Exception {
        throw const FormatException('Unsupported calendar time zone');
      }
    }
    return DateTime(year, month, day, hour ?? 0, minute ?? 0, second ?? 0);
  }
}

class IcalDateParser {
  const IcalDateParser();

  IcalDateTime parse(String raw, {String? valueParam, String? tzidParam}) {
    final value = raw.trim();
    if (!RegExp(r'^\d{8}(T\d{6}Z?)?$').hasMatch(value) ||
        (valueParam == 'DATE' && value.length != 8)) {
      throw const FormatException('Invalid calendar date format.');
    }
    final yearCheck = int.parse(value.substring(0, 4));
    final monthCheck = int.parse(value.substring(4, 6));
    final dayCheck = int.parse(value.substring(6, 8));
    final date = DateTime.utc(yearCheck, monthCheck, dayCheck);
    if (date.year != yearCheck ||
        date.month != monthCheck ||
        date.day != dayCheck) {
      throw const FormatException('Invalid calendar date.');
    }
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
    if (hour > 23 || minute > 59 || second > 60) {
      throw const FormatException('Invalid calendar time.');
    }
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
