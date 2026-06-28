import 'package:meta/meta.dart';

enum NoteKind { text, checklist }

@immutable
class ChecklistItem {
  const ChecklistItem({required this.label, this.checked = false});
  final String label;
  final bool checked;

  ChecklistItem copyWith({String? label, bool? checked}) => ChecklistItem(
    label: label ?? this.label,
    checked: checked ?? this.checked,
  );
}

@immutable
class NoteDraft {
  const NoteDraft({
    required this.collectionId,
    required this.title,
    required this.content,
    this.kind = NoteKind.text,
    this.category,
    this.favorite = false,
    this.locked = false,
  });

  final int collectionId;
  final String title;
  final String content;
  final NoteKind kind;
  final String? category;
  final bool favorite;
  final bool locked;

  NoteDraft copyWith({
    String? title,
    String? content,
    NoteKind? kind,
    String? category,
    bool? favorite,
    bool? locked,
  }) => NoteDraft(
    collectionId: collectionId,
    title: title ?? this.title,
    content: content ?? this.content,
    kind: kind ?? this.kind,
    category: category ?? this.category,
    favorite: favorite ?? this.favorite,
    locked: locked ?? this.locked,
  );
}
