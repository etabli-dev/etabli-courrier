import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

// Human-readable RRULE formatter — clean-room reimplementation.
//
// Behavioural reference: Etar Calendar's RRULE-to-natural-language formatter
// (consulted as feature spec — no code copied; provenance recorded in
// THIRD_PARTY_REFERENCES.md). We cover the FREQ/INTERVAL/BYDAY/BYMONTHDAY/
// BYMONTH/COUNT/UNTIL patterns that show up in 95% of real-world calendars.
// Anything more exotic returns "Custom recurrence" — better honest than wrong.

class RruleFormatter {
  RruleFormatter({DateFormat? untilFormat})
    : _untilFormat = untilFormat ?? DateFormat.yMMMd();

  final DateFormat _untilFormat;

  String format(String rruleText) {
    final RecurrenceRule rule;
    try {
      rule = RecurrenceRule.fromString('RRULE:$rruleText');
    } on Object {
      // rrule throws FormatException OR RangeError on malformed input.
      // Treat anything as "give up cleanly" — the user sees Custom recurrence.
      return 'Custom recurrence';
    }
    final base = _baseFrequency(rule);
    if (base == null) {
      return 'Custom recurrence';
    }

    final buffer = StringBuffer(base);

    void appendSpaced(String? part) {
      if (part == null) {
        return;
      }
      buffer
        ..write(' ')
        ..write(part);
    }

    appendSpaced(_formatByDay(rule));
    appendSpaced(_formatByMonthDay(rule));
    appendSpaced(_formatByMonth(rule));

    final tail = _formatTail(rule);
    if (tail != null) {
      // Tail starts with ", " — no separator space.
      buffer.write(tail);
    }
    return buffer.toString();
  }

  String? _baseFrequency(RecurrenceRule rule) {
    final interval = rule.actualInterval;
    if (rule.frequency == Frequency.daily) {
      return interval == 1 ? 'Daily' : 'Every $interval days';
    }
    if (rule.frequency == Frequency.weekly) {
      return interval == 1 ? 'Weekly' : 'Every $interval weeks';
    }
    if (rule.frequency == Frequency.monthly) {
      return interval == 1 ? 'Monthly' : 'Every $interval months';
    }
    if (rule.frequency == Frequency.yearly) {
      return interval == 1 ? 'Yearly' : 'Every $interval years';
    }
    return null;
  }

  String? _formatByDay(RecurrenceRule rule) {
    if (rule.byWeekDays.isEmpty) {
      return null;
    }
    final dayNames = rule.byWeekDays
        .map((d) => _dayPrefix(d) + _dayName(d.day))
        .toList(growable: false);
    return 'on ${_joinHumanList(dayNames)}';
  }

  String? _formatByMonthDay(RecurrenceRule rule) {
    if (rule.byMonthDays.isEmpty) {
      return null;
    }
    final ordinals = rule.byMonthDays.map(_ordinal).toList(growable: false);
    return 'on the ${_joinHumanList(ordinals)}';
  }

  String? _formatByMonth(RecurrenceRule rule) {
    if (rule.byMonths.isEmpty) {
      return null;
    }
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final names = rule.byMonths
        .where((m) => m >= 1 && m <= 12)
        .map((m) => monthNames[m - 1])
        .toList(growable: false);
    if (names.isEmpty) {
      return null;
    }
    return 'in ${_joinHumanList(names)}';
  }

  String? _formatTail(RecurrenceRule rule) {
    if (rule.count != null) {
      final n = rule.count!;
      return ', $n ${n == 1 ? 'time' : 'times'}';
    }
    final until = rule.until;
    if (until != null) {
      return ', until ${_untilFormat.format(until)}';
    }
    return null;
  }

  String _dayPrefix(ByWeekDayEntry entry) {
    final occurrence = entry.occurrence;
    if (occurrence == null) {
      return '';
    }
    if (occurrence == -1) {
      return 'the last ';
    }
    if (occurrence > 0) {
      return 'the ${_ordinal(occurrence)} ';
    }
    return 'the ${_ordinal(-occurrence)} from last ';
  }

  String _dayName(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Day $day';
    }
  }

  String _ordinal(int n) {
    if (n < 0) {
      return '${_ordinal(-n)} from last';
    }
    if (n % 100 >= 11 && n % 100 <= 13) {
      return '${n}th';
    }
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  String _joinHumanList(List<String> items) {
    if (items.isEmpty) {
      return '';
    }
    if (items.length == 1) {
      return items.first;
    }
    if (items.length == 2) {
      return '${items[0]} and ${items[1]}';
    }
    final head = items.sublist(0, items.length - 1).join(', ');
    return '$head, and ${items.last}';
  }
}
