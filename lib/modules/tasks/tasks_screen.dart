import 'package:flutter/material.dart';

import '../../core/db/database.dart';
import 'data/task_repository.dart';
import 'ui/task_list_view.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({required this.repository, super.key});

  final TaskRepository repository;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late Future<List<TodoItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.listTasks();
  }

  void _reload() {
    setState(() => _future = widget.repository.listTasks());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TodoItem>>(
      future: _future,
      builder: (context, snapshot) {
        final tasks = snapshot.data ?? const <TodoItem>[];
        return TaskListView(
          tasks: tasks,
          onToggleComplete: (task) async {
            await widget.repository.completeTask(task.id);
            _reload();
          },
        );
      },
    );
  }
}
