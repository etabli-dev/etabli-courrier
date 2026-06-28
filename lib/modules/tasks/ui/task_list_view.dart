import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/db/database.dart';
import '../../../core/theme/tokens.dart';

class TaskListView extends StatelessWidget {
  TaskListView({
    required this.tasks,
    this.onToggleComplete,
    this.onTaskTap,
    super.key,
  });

  final List<TodoItem> tasks;
  final ValueChanged<TodoItem>? onToggleComplete;
  final ValueChanged<TodoItem>? onTaskTap;

  final DateFormat _due = DateFormat.MMMEd();

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return _Empty();
    }
    final rows = _flattenWithDepth();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: CourrierTokens.space5,
        vertical: CourrierTokens.space3,
      ),
      itemCount: rows.length,
      separatorBuilder: (_, _) => const Divider(height: CourrierTokens.space4),
      itemBuilder: (context, i) {
        final row = rows[i];
        return _TaskRow(
          task: row.task,
          depth: row.depth,
          dueLabel: row.task.due == null ? null : _due.format(row.task.due!),
          onToggleComplete: onToggleComplete == null
              ? null
              : () => onToggleComplete!(row.task),
          onTap: onTaskTap == null ? null : () => onTaskTap!(row.task),
        );
      },
    );
  }

  // Two-pass flatten: roots in input order, each followed by its direct
  // children (then grandchildren, etc.). Tasks with an unknown parentUid are
  // treated as roots so a partial sync doesn't hide them.
  List<_FlatRow> _flattenWithDepth() {
    final byUid = {for (final t in tasks) t.uid: t};
    final childrenOf = <String, List<TodoItem>>{};
    final roots = <TodoItem>[];
    for (final task in tasks) {
      final parent = task.parentUid;
      if (parent != null && byUid.containsKey(parent)) {
        (childrenOf[parent] ??= <TodoItem>[]).add(task);
      } else {
        roots.add(task);
      }
    }
    final result = <_FlatRow>[];
    void visit(TodoItem task, int depth) {
      result.add(_FlatRow(task: task, depth: depth));
      final kids = childrenOf[task.uid];
      if (kids == null) {
        return;
      }
      for (final kid in kids) {
        visit(kid, depth + 1);
      }
    }

    for (final root in roots) {
      visit(root, 0);
    }
    return result;
  }
}

class _FlatRow {
  const _FlatRow({required this.task, required this.depth});
  final TodoItem task;
  final int depth;
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.depth,
    this.dueLabel,
    this.onToggleComplete,
    this.onTap,
  });

  final TodoItem task;
  final int depth;
  final String? dueLabel;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final complete = task.percentComplete == 100 || task.completed != null;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: CourrierTokens.space5 * depth,
          top: CourrierTokens.space2,
          bottom: CourrierTokens.space2,
        ),
        child: Row(
          children: [
            InkResponse(
              onTap: onToggleComplete,
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: complete
                        ? CourrierTokens.accent
                        : theme.dividerTheme.color!,
                  ),
                ),
                child: complete
                    ? const Icon(
                        Icons.check,
                        size: 14,
                        color: CourrierTokens.accent,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: CourrierTokens.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.summary ?? '(no summary)',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      decoration: complete ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (dueLabel != null)
                    Text(dueLabel!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(CourrierTokens.space6),
        child: Text(
          'No tasks yet.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
