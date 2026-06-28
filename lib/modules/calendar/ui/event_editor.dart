import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/tokens.dart';
import '../data/event_draft.dart';
import '../data/event_reminder_spec.dart';

// Compact event editor — only the fields M3 spec calls out (BUILD_PROMPT M3).
// Wider fields (TZID-aware time picker, attachment picker) land at M11 polish.

class EventEditor extends StatefulWidget {
  const EventEditor({
    required this.initialDraft,
    required this.onSave,
    this.onCancel,
    super.key,
  });

  final EventDraft initialDraft;
  final Future<void> Function(EventDraft draft) onSave;
  final VoidCallback? onCancel;

  @override
  State<EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  late EventDraft _draft;
  late final TextEditingController _summary;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late final TextEditingController _rrule;
  late final TextEditingController _organizer;
  late final TextEditingController _attendees;
  late List<EventReminderSpec> _reminders;

  final DateFormat _date = DateFormat.yMd();
  final DateFormat _time = DateFormat.Hm();

  @override
  void initState() {
    super.initState();
    _draft = widget.initialDraft;
    _summary = TextEditingController(text: _draft.summary);
    _location = TextEditingController(text: _draft.location ?? '');
    _description = TextEditingController(text: _draft.description ?? '');
    _rrule = TextEditingController(text: _draft.rrule ?? '');
    _organizer = TextEditingController(text: _draft.organizer ?? '');
    _attendees = TextEditingController(text: _draft.attendees.join('\n'));
    _reminders = List.of(_draft.reminders);
  }

  @override
  void dispose() {
    _summary.dispose();
    _location.dispose();
    _description.dispose();
    _rrule.dispose();
    _organizer.dispose();
    _attendees.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _summary,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: CourrierTokens.space4),
            Row(
              children: [
                Expanded(
                  child: _DateField(
                    label: 'Starts',
                    value: _draft.start,
                    allDay: _draft.allDay,
                    onChanged: (next) => setState(() {
                      _draft = _draft.copyWith(start: next);
                    }),
                    dateFmt: _date,
                    timeFmt: _time,
                  ),
                ),
                const SizedBox(width: CourrierTokens.space3),
                Expanded(
                  child: _DateField(
                    label: 'Ends',
                    value: _draft.end,
                    allDay: _draft.allDay,
                    onChanged: (next) => setState(() {
                      _draft = _draft.copyWith(end: next);
                    }),
                    dateFmt: _date,
                    timeFmt: _time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: CourrierTokens.space2),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: _draft.allDay,
              onChanged: (v) => setState(() {
                _draft = _draft.copyWith(allDay: v);
              }),
              title: Text(
                'All-day',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            TextField(
              controller: _location,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _rrule,
              decoration: const InputDecoration(
                labelText: 'Recurrence (RRULE)',
                hintText: 'FREQ=WEEKLY;BYDAY=MO',
              ),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _organizer,
              decoration: const InputDecoration(labelText: 'Organizer'),
            ),
            const SizedBox(height: CourrierTokens.space3),
            TextField(
              controller: _attendees,
              decoration: const InputDecoration(
                labelText: 'Attendees (one per line)',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: CourrierTokens.space4),
            _RemindersSection(
              reminders: _reminders,
              onAdd: () => setState(() {
                _reminders = [
                  ..._reminders,
                  const EventReminderSpec(minutesBeforeStart: 15),
                ];
              }),
              onRemove: (i) => setState(() {
                _reminders = [..._reminders]..removeAt(i);
              }),
            ),
            const SizedBox(height: CourrierTokens.space5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: CourrierTokens.space3),
                FilledButton(
                  onPressed: _onSavePressed,
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSavePressed() async {
    final updated = _draft.copyWith(
      summary: _summary.text.trim(),
      location: _location.text.isEmpty ? null : _location.text,
      description: _description.text.isEmpty ? null : _description.text,
      rrule: _rrule.text.isEmpty ? null : _rrule.text,
      organizer: _organizer.text.isEmpty ? null : _organizer.text,
      attendees: _attendees.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      reminders: _reminders,
    );
    await widget.onSave(updated);
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.allDay,
    required this.onChanged,
    required this.dateFmt,
    required this.timeFmt,
  });

  final String label;
  final DateTime value;
  final bool allDay;
  final ValueChanged<DateTime> onChanged;
  final DateFormat dateFmt;
  final DateFormat timeFmt;

  @override
  Widget build(BuildContext context) {
    final text = allDay
        ? dateFmt.format(value)
        : '${dateFmt.format(value)} ${timeFmt.format(value)}';
    return InkWell(
      onTap: () => _pick(context),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }

  Future<void> _pick(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(value.year - 5),
      lastDate: DateTime(value.year + 10),
    );
    if (date == null) {
      return;
    }
    var picked = DateTime(
      date.year,
      date.month,
      date.day,
      value.hour,
      value.minute,
    );
    if (!allDay && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(value),
      );
      if (time != null) {
        picked = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
    onChanged(picked);
  }
}

class _RemindersSection extends StatelessWidget {
  const _RemindersSection({
    required this.reminders,
    required this.onAdd,
    required this.onRemove,
  });

  final List<EventReminderSpec> reminders;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Reminders', style: theme.textTheme.bodyLarge),
            const Spacer(),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add reminder'),
            ),
          ],
        ),
        for (var i = 0; i < reminders.length; i++)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_none),
            title: Text(
              reminders[i].minutesBeforeStart != null
                  ? '${reminders[i].minutesBeforeStart} min before'
                  : 'At a specific time',
              style: theme.textTheme.bodyMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => onRemove(i),
              tooltip: 'Remove reminder',
            ),
          ),
      ],
    );
  }
}
