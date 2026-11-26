import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/db/database.dart';
import '../../l10n/l10n.dart';
import 'data/note_draft.dart';
import 'data/note_repository.dart';
import 'ui/note_editor.dart';
import 'ui/note_export.dart';
import 'ui/note_list_view.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({required this.repository, this.unlock, super.key});

  final NoteRepository repository;
  final Future<bool> Function()? unlock;

  Future<void> createNote(BuildContext context) => _edit(context, null);

  Future<void> _edit(BuildContext context, NoteItem? note) async {
    try {
      if (note?.locked == true && (unlock == null || !await unlock!())) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.notesUnlockRequired)),
          );
        }
        return;
      }
      if (!context.mounted) return;
      var collectionId = note?.collectionId;
      if (collectionId == null) {
        final db = repository.db;
        final collections = await (db.select(
          db.collections,
        )..where((t) => t.kind.equals('notes'))).get();
        if (!context.mounted) return;
        if (collections.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.notesNoCollection)),
          );
          return;
        }
        collectionId = collections.length == 1
            ? collections.single.id
            : await showDialog<int>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(context.l10n.notesChooseNotebook),
                  children: [
                    for (final collection in collections)
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, collection.id),
                        child: Text(collection.displayName),
                      ),
                  ],
                ),
              );
      }
      if (collectionId == null || !context.mounted) return;
      final draft = NoteDraft(
        collectionId: collectionId,
        title: note?.title ?? '',
        content: note?.content ?? '',
        kind: note?.kind == 'checklist' ? NoteKind.checklist : NoteKind.text,
        category: note?.category,
        favorite: note?.favorite ?? false,
        locked: note?.locked ?? false,
      );
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (editorContext) => Scaffold(
            appBar: AppBar(
              actions: [
                if (note != null &&
                    (Platform.isLinux ||
                        Platform.isMacOS ||
                        Platform.isWindows))
                  IconButton(
                    tooltip: 'Export checked note to Notes',
                    icon: const Icon(Icons.upload_file),
                    onPressed: () async {
                      try {
                        await exportCheckedNote(
                          editorContext,
                          repository.db,
                          note,
                        );
                      } catch (_) {
                        if (editorContext.mounted) {
                          ScaffoldMessenger.of(editorContext).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Export failed. Check the event file and short summary.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
              ],
              title: Text(
                note == null
                    ? editorContext.l10n.notesNew
                    : editorContext.l10n.notesEdit,
              ),
            ),
            body: SafeArea(
              child: NoteEditor(
                initialDraft: draft,
                allowLocking: unlock != null,
                onCancel: () => Navigator.pop(editorContext),
                onSaved: () => Navigator.pop(editorContext),
                onSave: (updated) async {
                  if (updated.locked &&
                      note?.locked != true &&
                      (unlock == null || !await unlock!())) {
                    throw StateError(
                      'Device authentication is required to lock a note.',
                    );
                  }
                  if (note == null) {
                    await repository.createNote(updated);
                  } else {
                    await repository.updateNote(note.id, updated);
                  }
                },
              ),
            ),
          ),
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.notesOpenFailed)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyN, control: true): () =>
            _edit(context, null),
        const SingleActivator(LogicalKeyboardKey.keyN, meta: true): () =>
            _edit(context, null),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _edit(context, null),
            tooltip: context.l10n.notesNew,
            child: const Icon(Icons.add),
          ),
          body: StreamBuilder<List<NoteItem>>(
            stream: repository.watchNotes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(context.l10n.notesLoadFailed));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return NoteListView(
                notes: snapshot.data!,
                onNoteTap: (note) => _edit(context, note),
              );
            },
          ),
        ),
      ),
    );
  }
}
