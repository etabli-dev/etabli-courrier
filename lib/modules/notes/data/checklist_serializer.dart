import 'note_draft.dart';

// Checklist ↔ markdown task-list round-trip. The on-disk form is plain
// markdown so opening the same note in any other markdown editor (Obsidian,
// Logseq, …) shows the same thing. We tolerate a couple of common variants
// on parse and emit the canonical form on serialise.
//
// Recognised:
//   - [ ] foo
//   - [x] foo
//   * [ ] foo            (asterisk bullet)
//   - [X] foo            (uppercase X)
//   plain text lines     (preserved as label-only ChecklistItem; canonical
//                         serialiser still emits `- [ ]` so the round-trip
//                         stays markdown-clean — see `decodeStrict` for the
//                         non-tolerant version used by the editor)

class ChecklistSerializer {
  const ChecklistSerializer();

  static final RegExp _checked = RegExp(r'^[*-]\s*\[\s*[xX]\s*\]\s*(.*)$');
  static final RegExp _unchecked = RegExp(r'^[*-]\s*\[\s*\]\s*(.*)$');

  /// Lenient parse — preserves plain lines as label-only items.
  List<ChecklistItem> decode(String markdown) {
    final lines = markdown.split('\n');
    final items = <ChecklistItem>[];
    for (final raw in lines) {
      if (raw.trim().isEmpty) {
        continue;
      }
      final checked = _checked.firstMatch(raw);
      if (checked != null) {
        items.add(ChecklistItem(label: checked.group(1) ?? '', checked: true));
        continue;
      }
      final unchecked = _unchecked.firstMatch(raw);
      if (unchecked != null) {
        items.add(ChecklistItem(label: unchecked.group(1) ?? ''));
        continue;
      }
      items.add(ChecklistItem(label: raw.trim()));
    }
    return List<ChecklistItem>.unmodifiable(items);
  }

  /// Strict parse — only recognised task-list lines become items. Plain
  /// lines are dropped. Used by the editor to detect when the content has
  /// drifted away from being a checklist.
  List<ChecklistItem>? decodeStrict(String markdown) {
    final lines = markdown
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();
    final items = <ChecklistItem>[];
    for (final raw in lines) {
      final checked = _checked.firstMatch(raw);
      if (checked != null) {
        items.add(ChecklistItem(label: checked.group(1) ?? '', checked: true));
        continue;
      }
      final unchecked = _unchecked.firstMatch(raw);
      if (unchecked != null) {
        items.add(ChecklistItem(label: unchecked.group(1) ?? ''));
        continue;
      }
      return null;
    }
    return List<ChecklistItem>.unmodifiable(items);
  }

  /// Canonical markdown form — `- [ ]` / `- [x]` per item, one per line.
  String encode(List<ChecklistItem> items) {
    return items
        .map((item) => '- [${item.checked ? 'x' : ' '}] ${item.label}')
        .join('\n');
  }
}
