import 'package:meta/meta.dart';

// Simple bounded undo/redo stack for the note editor.
// One snapshot per "commit"; the editor commits whenever the user pauses
// typing for >500ms or toggles checklist mode.

@immutable
class EditorSnapshot {
  const EditorSnapshot({required this.title, required this.content});
  final String title;
  final String content;

  @override
  bool operator ==(Object other) =>
      other is EditorSnapshot &&
      other.title == title &&
      other.content == content;

  @override
  int get hashCode => Object.hash(title, content);
}

class NoteEditorHistory {
  NoteEditorHistory(EditorSnapshot initial, {this.cap = 50})
    : _stack = [initial],
      _cursor = 0;

  final List<EditorSnapshot> _stack;
  final int cap;
  int _cursor;

  EditorSnapshot get current => _stack[_cursor];
  bool get canUndo => _cursor > 0;
  bool get canRedo => _cursor < _stack.length - 1;
  int get length => _stack.length;

  /// Commit a new snapshot. Identical-to-current commits are coalesced
  /// (no-op) so quick double-presses don't blow up the stack.
  void commit(EditorSnapshot snapshot) {
    if (current == snapshot) {
      return;
    }
    // Drop any redo-future when the user makes a new edit after undoing.
    if (_cursor < _stack.length - 1) {
      _stack.removeRange(_cursor + 1, _stack.length);
    }
    _stack.add(snapshot);
    if (_stack.length > cap) {
      _stack.removeAt(0);
    } else {
      _cursor += 1;
    }
  }

  EditorSnapshot? undo() {
    if (!canUndo) {
      return null;
    }
    _cursor -= 1;
    return current;
  }

  EditorSnapshot? redo() {
    if (!canRedo) {
      return null;
    }
    _cursor += 1;
    return current;
  }
}
