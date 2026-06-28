import 'package:courrier/modules/notes/data/checklist_serializer.dart';
import 'package:courrier/modules/notes/data/note_draft.dart';
import 'package:flutter_test/flutter_test.dart';

const _serializer = ChecklistSerializer();

void main() {
  group('ChecklistSerializer.decode (lenient)', () {
    test('Recognises `- [ ]` + `- [x]` + `* [X]` + asterisk bullet', () {
      const markdown = '- [ ] a\n- [x] b\n* [X] c';
      final items = _serializer.decode(markdown);
      expect(items, hasLength(3));
      expect(items[0].label, 'a');
      expect(items[0].checked, isFalse);
      expect(items[1].label, 'b');
      expect(items[1].checked, isTrue);
      expect(items[2].label, 'c');
      expect(items[2].checked, isTrue);
    });

    test('Preserves plain lines as label-only items', () {
      final items = _serializer.decode('grocery list\n- [ ] milk');
      expect(items, hasLength(2));
      expect(items.first.label, 'grocery list');
      expect(items.first.checked, isFalse);
      expect(items.last.label, 'milk');
    });

    test('Skips empty lines', () {
      final items = _serializer.decode('- [ ] a\n\n- [x] b\n');
      expect(items, hasLength(2));
    });
  });

  group('ChecklistSerializer.decodeStrict', () {
    test('Returns null when any non-task line is present', () {
      expect(_serializer.decodeStrict('hello world'), isNull);
      expect(_serializer.decodeStrict('- [ ] ok\nrandom'), isNull);
    });

    test('Returns items when every line is a task', () {
      final items = _serializer.decodeStrict('- [ ] ok\n- [x] done');
      expect(items, isNotNull);
      expect(items, hasLength(2));
    });
  });

  group('ChecklistSerializer.encode', () {
    test('Emits canonical `- [ ]` / `- [x]` per item', () {
      const items = [
        ChecklistItem(label: 'first'),
        ChecklistItem(label: 'second', checked: true),
      ];
      final encoded = _serializer.encode(items);
      expect(encoded, '- [ ] first\n- [x] second');
    });

    test('Round-trip through decode → encode normalises to canonical form', () {
      const input = '* [X] one\n- [ ] two\n- [x] three';
      final encoded = _serializer.encode(_serializer.decode(input));
      expect(encoded, '- [x] one\n- [ ] two\n- [x] three');
      // And the re-round-trip is stable.
      final roundTwo = _serializer.encode(_serializer.decode(encoded));
      expect(roundTwo, encoded);
    });
  });
}
