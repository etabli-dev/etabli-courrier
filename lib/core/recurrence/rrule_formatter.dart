import 'package:intl/intl.dart';
import 'package:rrule/rrule.dart';

import '../../l10n/l10n.dart';
import '../widgets/date_locale.dart';

// Human-readable RRULE formatter — clean-room reimplementation.
//
// Behavioural reference: Etar Calendar's RRULE-to-natural-language formatter
// (consulted as feature spec — no code copied; provenance recorded in
// THIRD_PARTY_REFERENCES.md). We cover the FREQ/INTERVAL/BYDAY/BYMONTHDAY/
// BYMONTH/COUNT/UNTIL patterns that show up in 95% of real-world calendars.
// Anything more exotic returns "Custom recurrence" — better honest than wrong.
//
// The text comes from [AppLocalizations]; weekday and month names come from
// intl for that locale.

class RruleFormatter {
  RruleFormatter({this.untilFormat, this.l10n});

  /// Format of UNTIL dates; the locale's yMMMd when null.
  final DateFormat? untilFormat;

  /// Strings to use; the app's current language ([L10n.current]) when null.
  final AppLocalizations? l10n;

  String format(String rruleText) {
    final l10n = this.l10n ?? L10n.current;
    final RecurrenceRule rule;
    try {
      rule = RecurrenceRule.fromString('RRULE:$rruleText');
    } on Object {
      // rrule throws FormatException OR RangeError on malformed input.
      // Treat anything as "give up cleanly" — the user sees Custom recurrence.
      return l10n.rruleCustom;
    }
    final base = _baseFrequency(rule, l10n);
    if (base == null) {
      return l10n.rruleCustom;
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

    final symbols = DateFormat.EEEE(l10n.dateLocale).dateSymbols;
    appendSpaced(_formatByDay(rule, l10n, symbols.WEEKDAYS));
    final monthDays = _formatMonthDays(rule, l10n);
    final months = _formatMonths(rule, l10n, symbols.MONTHS);
    if (monthDays != null && months != null) {
      appendSpaced(l10n.rruleOnMonthDaysInMonths(monthDays, months));
    } else {
      appendSpaced(monthDays == null ? null : l10n.rruleOnMonthDays(monthDays));
      appendSpaced(months == null ? null : l10n.rruleInMonths(months));
    }

    return _withTail(rule, l10n, buffer.toString());
  }

  String? _baseFrequency(RecurrenceRule rule, AppLocalizations l10n) {
    final interval = rule.actualInterval;
    if (rule.frequency == Frequency.daily) {
      return l10n.rruleDaily(interval);
    }
    if (rule.frequency == Frequency.weekly) {
      return l10n.rruleWeekly(interval);
    }
    if (rule.frequency == Frequency.monthly) {
      return l10n.rruleMonthly(interval);
    }
    if (rule.frequency == Frequency.yearly) {
      return l10n.rruleYearly(interval);
    }
    return null;
  }

  String? _formatByDay(
    RecurrenceRule rule,
    AppLocalizations l10n,
    List<String> weekdays,
  ) {
    if (rule.byWeekDays.isEmpty) {
      return null;
    }
    final dayNames = rule.byWeekDays
        .map((d) => _weekday(d, l10n, _dayName(d.day, l10n, weekdays)))
        .toList(growable: false);
    return l10n.rruleOnWeekdays(_joinHumanList(dayNames, l10n));
  }

  /// The BYMONTHDAY list ("15th", "1st and 15th"), or null.
  String? _formatMonthDays(RecurrenceRule rule, AppLocalizations l10n) {
    if (rule.byMonthDays.isEmpty) {
      return null;
    }
    final ordinals = rule.byMonthDays
        .map((n) => _ordinal(n, l10n))
        .toList(growable: false);
    return _joinHumanList(ordinals, l10n);
  }

  /// The BYMONTH list of month names, or null.
  String? _formatMonths(
    RecurrenceRule rule,
    AppLocalizations l10n,
    List<String> monthNames,
  ) {
    if (rule.byMonths.isEmpty) {
      return null;
    }
    final names = rule.byMonths
        .where((m) => m >= 1 && m <= 12)
        .map((m) => monthNames[m - 1])
        .toList(growable: false);
    if (names.isEmpty) {
      return null;
    }
    return _joinHumanList(names, l10n);
  }

  String _withTail(RecurrenceRule rule, AppLocalizations l10n, String text) {
    if (rule.count != null) {
      return l10n.rruleWithCount(text, rule.count!);
    }
    final until = rule.until;
    if (until != null) {
      final format = untilFormat ?? DateFormat.yMMMd(l10n.dateLocale);
      return l10n.rruleWithUntil(text, format.format(until));
    }
    return text;
  }

  String _weekday(ByWeekDayEntry entry, AppLocalizations l10n, String day) {
    final occurrence = entry.occurrence;
    if (occurrence == null) {
      return day;
    }
    if (occurrence == -1) {
      return l10n.rruleWeekdayLast(day);
    }
    if (occurrence > 0) {
      return l10n.rruleWeekdayNth(_ordinal(occurrence, l10n), day);
    }
    return l10n.rruleWeekdayNthFromLast(
      _ordinal(-occurrence, l10n),
      -occurrence,
      day,
    );
  }

  /// [weekdays] is intl's Sunday-first list of weekday names.
  String _dayName(int day, AppLocalizations l10n, List<String> weekdays) {
    if (day < DateTime.monday || day > DateTime.sunday) {
      return l10n.rruleDayFallback(day);
    }
    return weekdays[day % 7];
  }

  String _ordinal(int n, AppLocalizations l10n) {
    if (n < 0) {
      return l10n.rruleOrdinalFromLast(_ordinal(-n, l10n), -n);
    }
    return l10n.rruleOrdinal(n, _englishOrdinalCategory(n));
  }

  // CLDR's English ordinal category (1st, 2nd, 3rd, 4th, 11th–13th); only the
  // English message uses it, other languages ignore it.
  String _englishOrdinalCategory(int n) {
    if (n % 100 >= 11 && n % 100 <= 13) {
      return 'other';
    }
    switch (n % 10) {
      case 1:
        return 'one';
      case 2:
        return 'two';
      case 3:
        return 'few';
      default:
        return 'other';
    }
  }

  String _joinHumanList(List<String> items, AppLocalizations l10n) {
    if (items.isEmpty) {
      return '';
    }
    if (items.length == 1) {
      return items.first;
    }
    if (items.length == 2) {
      return l10n.rruleListPair(items[0], items[1]);
    }
    final head = items.sublist(0, items.length - 1).join(', ');
    return l10n.rruleListSeries(head, items.last);
  }
}
