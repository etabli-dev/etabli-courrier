import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    required this.monthStart,
    required this.events,
    this.onDayTap,
    super.key,
  });

  /// First day of the month being shown.
  final DateTime monthStart;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime>? onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final monthLabel = DateFormat.yMMMM().format(monthStart);
    final grid = _buildGrid();
    final eventsByDate = _bucketEventsByDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(CourrierTokens.space5),
          child: Text(monthLabel, style: theme.textTheme.titleMedium),
        ),
        Row(
          children: [
            for (final label in dayLabels)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: CourrierTokens.space2,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            childAspectRatio: 0.85,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final cell in grid)
                _DayCell(
                  date: cell.date,
                  inMonth: cell.inMonth,
                  hasEvents: eventsByDate[cell.dateKey] ?? false,
                  onTap: cell.inMonth && onDayTap != null
                      ? () => onDayTap!(cell.date)
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<_MonthCell> _buildGrid() {
    final firstWeekday = monthStart.weekday; // Monday=1, Sunday=7
    final leading = firstWeekday - 1;
    final daysInMonth = DateTime(monthStart.year, monthStart.month + 1, 0).day;
    final cells = <_MonthCell>[];
    for (var i = 0; i < leading; i++) {
      final date = monthStart.subtract(Duration(days: leading - i));
      cells.add(_MonthCell(date: date, inMonth: false));
    }
    for (var d = 1; d <= daysInMonth; d++) {
      cells.add(
        _MonthCell(
          date: DateTime(monthStart.year, monthStart.month, d),
          inMonth: true,
        ),
      );
    }
    while (cells.length % 7 != 0) {
      cells.add(
        _MonthCell(
          date: cells.last.date.add(const Duration(days: 1)),
          inMonth: false,
        ),
      );
    }
    return cells;
  }

  Map<String, bool> _bucketEventsByDate() {
    final map = <String, bool>{};
    for (final event in events) {
      final dt = event.dtstart;
      if (dt == null) {
        continue;
      }
      map[_keyFor(dt)] = true;
    }
    return map;
  }

  static String _keyFor(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _MonthCell {
  _MonthCell({required this.date, required this.inMonth});

  final DateTime date;
  final bool inMonth;
  String get dateKey => MonthView._keyFor(date);
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.inMonth,
    required this.hasEvents,
    this.onTap,
  });

  final DateTime date;
  final bool inMonth;
  final bool hasEvents;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = inMonth
        ? theme.textTheme.bodyMedium
        : theme.textTheme.bodySmall;

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.dividerTheme.color!),
            left: BorderSide(color: theme.dividerTheme.color!),
          ),
        ),
        padding: const EdgeInsets.all(CourrierTokens.space2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${date.day}', style: textStyle),
            const Spacer(),
            if (hasEvents && inMonth)
              Container(width: 5, height: 5, color: CourrierTokens.accent),
          ],
        ),
      ),
    );
  }
}
