import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import 'data/note_repository.dart';
import 'ui/note_list_view.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({required this.repository, super.key});

  final NoteRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NoteItem>>(
      stream: repository.watchNotes(),
      builder: (context, snapshot) {
        final notes = snapshot.data ?? const <NoteItem>[];
        return NoteListView(notes: notes);
      },
    );
  }
}
