import 'package:flutter/material.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';

class NoteListView extends StatelessWidget {
  const NoteListView({required this.notes, this.onNoteTap, super.key});

  final List<NoteItem> notes;
  final ValueChanged<NoteItem>? onNoteTap;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const _Empty();
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space3,
      ),
      itemCount: notes.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space4),
      itemBuilder: (context, i) {
        final note = notes[i];
        return _NoteTile(
          note: note,
          onTap: onNoteTap == null ? null : () => onNoteTap!(note),
        );
      },
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note, this.onTap});

  final NoteItem note;
  final VoidCallback? onTap;

  String get _preview {
    final raw = note.locked ? '(locked)' : note.content;
    final firstLine = raw
        .split('\n')
        .firstWhere((l) => l.trim().isNotEmpty, orElse: () => '');
    if (firstLine.length <= 120) {
      return firstLine;
    }
    return '${firstLine.substring(0, 120)}…';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CourrierTokens.space2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.favorite)
              const Padding(
                padding: EdgeInsets.only(top: 2, right: CourrierTokens.space2),
                child: Icon(Icons.star, size: 16, color: CourrierTokens.accent),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (note.locked) const Icon(Icons.lock, size: 14),
                      if (note.kind == 'checklist') ...[
                        const SizedBox(width: CourrierTokens.space2),
                        Text('checklist', style: theme.textTheme.bodySmall),
                      ],
                    ],
                  ),
                  const SizedBox(height: CourrierTokens.space1),
                  Text(_preview, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space6),
        child: Text(
          'No notes yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
