import 'package:courrier/modules/notes/ui/undo_history.dart';
import 'package:flutter_test/flutter_test.dart';

EditorSnapshot _s(String t, String c) => EditorSnapshot(title: t, content: c);

void main() {
  group('NoteEditorHistory', () {
    test('initial state: canUndo=false, canRedo=false', () {
      final h = NoteEditorHistory(_s('', ''));
      expect(h.canUndo, isFalse);
      expect(h.canRedo, isFalse);
      expect(h.length, 1);
    });

    test('commit grows the stack; undo + redo navigate', () {
      final h = NoteEditorHistory(_s('a', ''));
      h.commit(_s('ab', ''));
      h.commit(_s('abc', ''));
      expect(h.length, 3);
      expect(h.current.title, 'abc');
      expect(h.canUndo, isTrue);

      final undo1 = h.undo();
      expect(undo1?.title, 'ab');
      expect(h.canRedo, isTrue);

      final redo = h.redo();
      expect(redo?.title, 'abc');
      expect(h.canRedo, isFalse);
    });

    test('commit identical-to-current is a no-op', () {
      final h = NoteEditorHistory(_s('a', 'b'));
      h.commit(_s('a', 'b'));
      h.commit(_s('a', 'b'));
      expect(h.length, 1);
    });

    test('committing after undo drops the redo future', () {
      final h = NoteEditorHistory(_s('a', ''));
      h.commit(_s('b', ''));
      h.commit(_s('c', ''));
      h.undo(); // back to 'b'
      h.commit(_s('d', ''));
      expect(h.canRedo, isFalse);
      expect(h.current.title, 'd');
    });

    test('cap drops the oldest snapshot once exceeded', () {
      final h = NoteEditorHistory(_s('0', ''), cap: 3);
      h.commit(_s('1', ''));
      h.commit(_s('2', ''));
      h.commit(_s('3', ''));
      h.commit(_s('4', ''));
      expect(h.length, 3);
      while (h.canUndo) {
        h.undo();
      }
      expect(h.current.title, '2');
    });
  });
}
