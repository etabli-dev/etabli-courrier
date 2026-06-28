import 'package:meta/meta.dart';

// Editor-side payload — pure data, no IO. Mirrors EventDraft's shape.
// Subtask wiring is by `parentUid` (matches the M1 schema column and the
// RFC 5545 RELATED-TO;RELTYPE=PARENT convention surfaced at M2 by VTodo).

@immutable
class TaskDraft {
  const TaskDraft({
    required this.collectionId,
    required this.summary,
    this.uid,
    this.description,
    this.due,
    this.priority,
    this.percentComplete,
    this.rrule,
    this.repeatAfterCompletion = false,
    this.parentUid,
  });

  final int collectionId;
  final String? uid;
  final String summary;
  final String? description;
  final DateTime? due;
  final int? priority;
  final int? percentComplete;
  final String? rrule;
  final bool repeatAfterCompletion;
  final String? parentUid;

  TaskDraft copyWith({
    String? summary,
    String? description,
    DateTime? due,
    int? priority,
    int? percentComplete,
    String? rrule,
    bool? repeatAfterCompletion,
    String? parentUid,
  }) => TaskDraft(
    collectionId: collectionId,
    uid: uid,
    summary: summary ?? this.summary,
    description: description ?? this.description,
    due: due ?? this.due,
    priority: priority ?? this.priority,
    percentComplete: percentComplete ?? this.percentComplete,
    rrule: rrule ?? this.rrule,
    repeatAfterCompletion: repeatAfterCompletion ?? this.repeatAfterCompletion,
    parentUid: parentUid ?? this.parentUid,
  );
}
