import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../l10n/l10n.dart';
import '../data/note_draft.dart';
import 'undo_history.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({
    required this.initialDraft,
    required this.onSave,
    this.onCancel,
    this.onSaved,
    this.allowLocking = true,
    super.key,
  });

  final NoteDraft initialDraft;
  final Future<void> Function(NoteDraft draft) onSave;
  final VoidCallback? onCancel;
  final VoidCallback? onSaved;
  final bool allowLocking;

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
  bool _saving = false;
  bool _allowPop = false;
  bool _saveFailed = false;

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

  bool get _dirty {
    final original = widget.initialDraft;
    return _title.text != original.title ||
        _content.text != original.content ||
        _kind != original.kind ||
        _favorite != original.favorite ||
        _locked != original.locked;
  }

  Future<void> _leave({bool cancel = false}) async {
    if (_saving) return;
    if (_dirty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.notesDiscardTitle),
          content: Text(context.l10n.notesDiscardBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.notesKeepEditing),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.notesDiscard),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    if (cancel && widget.onCancel != null) {
      widget.onCancel!();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return PopScope(
      canPop: _allowPop || (!_dirty && !_saving),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _leave();
      },
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: _history.canUndo ? _undo : null,
                  tooltip: l10n.notesUndo,
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  onPressed: _history.canRedo ? _redo : null,
                  tooltip: l10n.notesRedo,
                ),
                IconButton(
                  icon: Icon(_favorite ? Icons.star : Icons.star_border),
                  onPressed: () => setState(() => _favorite = !_favorite),
                  tooltip: l10n.notesFavorite,
                  color: _favorite
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                IconButton(
                  icon: Icon(_locked ? Icons.lock : Icons.lock_open),
                  onPressed: widget.allowLocking
                      ? () => setState(() => _locked = !_locked)
                      : null,
                  tooltip: widget.allowLocking
                      ? l10n.notesLock
                      : l10n.notesLockUnavailable,
                ),
                SegmentedButton<NoteKind>(
                  segments: [
                    ButtonSegment(
                      value: NoteKind.text,
                      label: Text(l10n.notesKindText),
                    ),
                    ButtonSegment(
                      value: NoteKind.checklist,
                      label: Text(l10n.notesKindChecklist),
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
              decoration: InputDecoration(labelText: l10n.notesTitleLabel),
            ),
            const SizedBox(height: CourrierTokens.space3),
            Expanded(
              child: TextField(
                controller: _content,
                decoration: InputDecoration(
                  labelText: l10n.notesContentLabel,
                  hintText: l10n.notesContentHint,
                ),
                minLines: 8,
                maxLines: null,
              ),
            ),
            const SizedBox(height: CourrierTokens.space3),
            if (_saveFailed)
              Text(
                l10n.notesSaveFailed,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: _saving ? null : () => _leave(cancel: true),
                    child: Text(l10n.commonCancel),
                  ),
                const SizedBox(width: CourrierTokens.space2),
                FilledButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          setState(() {
                            _saving = true;
                            _saveFailed = false;
                          });
                          try {
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
                            if (mounted && widget.onSaved != null) {
                              setState(() => _allowPop = true);
                              await WidgetsBinding.instance.endOfFrame;
                              if (mounted) widget.onSaved!();
                            }
                          } catch (_) {
                            if (mounted) {
                              setState(() => _saveFailed = true);
                            }
                          } finally {
                            if (mounted) setState(() => _saving = false);
                          }
                        },
                  child: Text(_saving ? l10n.notesSaving : l10n.commonSave),
                ),
              ],
            ),
            const SizedBox(height: CourrierTokens.space2),
            Text(
              l10n.notesHistoryCount(_history.length),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
