import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
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
  String? _saveError;

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
          title: const Text('Discard unsaved changes?'),
          content: const Text('Your saved note will stay unchanged.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep editing'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard'),
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
                  tooltip: 'Undo',
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  onPressed: _history.canRedo ? _redo : null,
                  tooltip: 'Redo',
                ),
                IconButton(
                  icon: Icon(_favorite ? Icons.star : Icons.star_border),
                  onPressed: () => setState(() => _favorite = !_favorite),
                  tooltip: 'Favorite',
                  color: _favorite ? CourrierTokens.accent : null,
                ),
                IconButton(
                  icon: Icon(_locked ? Icons.lock : Icons.lock_open),
                  onPressed: widget.allowLocking
                      ? () => setState(() => _locked = !_locked)
                      : null,
                  tooltip: widget.allowLocking
                      ? 'Lock'
                      : 'Configure an app lock first',
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
            if (_saveError != null)
              Text(
                _saveError!,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onCancel != null)
                  TextButton(
                    onPressed: _saving ? null : () => _leave(cancel: true),
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: CourrierTokens.space2),
                FilledButton(
                  onPressed: _saving
                      ? null
                      : () async {
                          setState(() {
                            _saving = true;
                            _saveError = null;
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
                              setState(
                                () => _saveError =
                                    'Could not save this note. Your draft is still here; try again.',
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _saving = false);
                          }
                        },
                  child: Text(_saving ? 'Saving…' : 'Save'),
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
      ),
    );
  }
}
