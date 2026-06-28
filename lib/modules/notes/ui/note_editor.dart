import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../data/note_draft.dart';
import 'undo_history.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({
    required this.initialDraft,
    required this.onSave,
    this.onCancel,
    super.key,
  });

  final NoteDraft initialDraft;
  final Future<void> Function(NoteDraft draft) onSave;
  final VoidCallback? onCancel;

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _title;
  late TextEditingController _content;
  late NoteKind _kind;
  late bool _favorite;
  late bool _locked;
  late NoteEditorHistory _history;
  bool _suppressNextCommit = false;

  @override
  void initState() {
    super.initState();
    final d = widget.initialDraft;
    _title = TextEditingController(text: d.title);
    _content = TextEditingController(text: d.content);
    _kind = d.kind;
    _favorite = d.favorite;
    _locked = d.locked;
    _history = NoteEditorHistory(
      EditorSnapshot(title: _title.text, content: _content.text),
    );
    _title.addListener(_onFieldChanged);
    _content.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (_suppressNextCommit) {
      _suppressNextCommit = false;
      return;
    }
    _history.commit(EditorSnapshot(title: _title.text, content: _content.text));
    setState(() {});
  }

  void _restoreSnapshot(EditorSnapshot snapshot) {
    _suppressNextCommit = true;
    _title.value = TextEditingValue(
      text: snapshot.title,
      selection: TextSelection.collapsed(offset: snapshot.title.length),
    );
    _suppressNextCommit = true;
    _content.value = TextEditingValue(
      text: snapshot.content,
      selection: TextSelection.collapsed(offset: snapshot.content.length),
    );
    setState(() {});
  }

  void _undo() {
    final snapshot = _history.undo();
    if (snapshot != null) {
      _restoreSnapshot(snapshot);
    }
  }

  void _redo() {
    final snapshot = _history.redo();
    if (snapshot != null) {
      _restoreSnapshot(snapshot);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: _history.canUndo ? _undo : null,
                tooltip: 'Undo',
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: _history.canRedo ? _redo : null,
                tooltip: 'Redo',
              ),
              const Spacer(),
              IconButton(
                icon: Icon(_favorite ? Icons.star : Icons.star_border),
                onPressed: () => setState(() => _favorite = !_favorite),
                tooltip: 'Favorite',
                color: _favorite ? CourrierTokens.accent : null,
              ),
              IconButton(
                icon: Icon(_locked ? Icons.lock : Icons.lock_open),
                onPressed: () => setState(() => _locked = !_locked),
                tooltip: 'Lock',
              ),
              SegmentedButton<NoteKind>(
                segments: const [
                  ButtonSegment(value: NoteKind.text, label: Text('Text')),
                  ButtonSegment(
                    value: NoteKind.checklist,
                    label: Text('Checklist'),
                  ),
                ],
                selected: {_kind},
                onSelectionChanged: (s) => setState(() => _kind = s.first),
              ),
            ],
          ),
          const SizedBox(height: CourrierTokens.space3),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: CourrierTokens.space3),
          Expanded(
            child: TextField(
              controller: _content,
              decoration: const InputDecoration(
                labelText: 'Content',
                hintText: 'Type — checklist mode uses markdown task lists.',
              ),
              minLines: 8,
              maxLines: null,
            ),
          ),
          const SizedBox(height: CourrierTokens.space3),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onCancel != null)
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              const SizedBox(width: CourrierTokens.space2),
              FilledButton(
                onPressed: () async {
                  await widget.onSave(
                    NoteDraft(
                      collectionId: widget.initialDraft.collectionId,
                      title: _title.text,
                      content: _content.text,
                      kind: _kind,
                      category: widget.initialDraft.category,
                      favorite: _favorite,
                      locked: _locked,
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: CourrierTokens.space2),
          Text(
            '${_history.length} edit${_history.length == 1 ? '' : 's'} '
            'in history',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
