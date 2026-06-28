import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import '../../core/theme/tokens.dart';
import 'data/calendar_repository.dart';
import 'ui/agenda_view.dart';
import 'ui/month_view.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({required this.repository, super.key});

  final CalendarRepository repository;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

enum _Mode { agenda, month }

class _CalendarScreenState extends State<CalendarScreen> {
  _Mode _mode = _Mode.agenda;
  late DateTime _monthStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _monthStart = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final monthEnd = DateTime(
      _monthStart.year,
      _monthStart.month + 1,
    ).subtract(const Duration(seconds: 1));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CourrierTokens.space5,
            vertical: CourrierTokens.space3,
          ),
          child: Row(
            children: [
              SegmentedButton<_Mode>(
                segments: const [
                  ButtonSegment(value: _Mode.agenda, label: Text('Agenda')),
                  ButtonSegment(value: _Mode.month, label: Text('Month')),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<CalendarEvent>>(
            future: widget.repository.eventsBetween(
              from: _monthStart,
              to: monthEnd,
            ),
            builder: (context, snapshot) {
              final events = snapshot.data ?? const <CalendarEvent>[];
              switch (_mode) {
                case _Mode.agenda:
                  return AgendaView(events: events);
                case _Mode.month:
                  return MonthView(monthStart: _monthStart, events: events);
              }
            },
          ),
        ),
      ],
    );
  }
}
