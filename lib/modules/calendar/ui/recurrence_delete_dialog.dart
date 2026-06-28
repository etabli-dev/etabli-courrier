import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

// "Delete recurring event" UX (audit dim 8 / BUILD_PROMPT M3): the user picks
// THIS occurrence, THIS AND FOLLOWING, or ALL occurrences. The repository
// turns the choice into either an EXDATE row, an UNTIL truncation, or a full
// delete — see CalendarRepository.

enum RecurrenceDeleteScope { thisOccurrence, thisAndFollowing, all }

class RecurrenceDeleteDialog extends StatelessWidget {
  const RecurrenceDeleteDialog({super.key});

  static Future<RecurrenceDeleteScope?> show(BuildContext context) {
    return showDialog<RecurrenceDeleteScope>(
      context: context,
      builder: (_) => const RecurrenceDeleteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      title: Text('Delete recurring event'),
      contentPadding: EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space4,
      ),
      children: [
        _OptionTile(
          label: 'This occurrence only',
          value: RecurrenceDeleteScope.thisOccurrence,
        ),
        _OptionTile(
          label: 'This and following occurrences',
          value: RecurrenceDeleteScope.thisAndFollowing,
        ),
        _OptionTile(label: 'All occurrences', value: RecurrenceDeleteScope.all),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.value});

  final String label;
  final RecurrenceDeleteScope value;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () => Navigator.of(context).pop(value),
      child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
