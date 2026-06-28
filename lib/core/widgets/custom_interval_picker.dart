import 'package:flutter/material.dart';

import '../theme/tokens.dart';

// Shared interval picker used by Feeds (refresh interval) and the M11
// reminder editor. Surfaces a number + unit segmented button. Persists as
// integer minutes via [onChanged].

enum IntervalUnit { minutes, hours, days }

class CustomIntervalPicker extends StatefulWidget {
  const CustomIntervalPicker({
    required this.initialMinutes,
    required this.onChanged,
    this.label,
    super.key,
  });

  final int initialMinutes;
  final ValueChanged<int> onChanged;
  final String? label;

  @override
  State<CustomIntervalPicker> createState() => _CustomIntervalPickerState();
}

class _CustomIntervalPickerState extends State<CustomIntervalPicker> {
  late int _amount;
  late IntervalUnit _unit;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _normalize(widget.initialMinutes);
    _amountController = TextEditingController(text: _amount.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _normalize(int minutes) {
    if (minutes >= 1440 && minutes % 1440 == 0) {
      _unit = IntervalUnit.days;
      _amount = minutes ~/ 1440;
    } else if (minutes >= 60 && minutes % 60 == 0) {
      _unit = IntervalUnit.hours;
      _amount = minutes ~/ 60;
    } else {
      _unit = IntervalUnit.minutes;
      _amount = minutes;
    }
  }

  int _toMinutes() {
    switch (_unit) {
      case IntervalUnit.minutes:
        return _amount;
      case IntervalUnit.hours:
        return _amount * 60;
      case IntervalUnit.days:
        return _amount * 1440;
    }
  }

  void _emit() {
    final minutes = _toMinutes();
    if (minutes > 0) {
      widget.onChanged(minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: theme.textTheme.bodyMedium),
          const SizedBox(height: CourrierTokens.space2),
        ],
        Row(
          children: [
            SizedBox(
              width: 72,
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = int.tryParse(value);
                  if (parsed != null && parsed > 0) {
                    setState(() => _amount = parsed);
                    _emit();
                  }
                },
              ),
            ),
            const SizedBox(width: CourrierTokens.space3),
            SegmentedButton<IntervalUnit>(
              segments: const [
                ButtonSegment(value: IntervalUnit.minutes, label: Text('min')),
                ButtonSegment(value: IntervalUnit.hours, label: Text('hr')),
                ButtonSegment(value: IntervalUnit.days, label: Text('day')),
              ],
              selected: {_unit},
              onSelectionChanged: (s) {
                setState(() => _unit = s.first);
                _emit();
              },
            ),
          ],
        ),
      ],
    );
  }
}
