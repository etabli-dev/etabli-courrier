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
  bool _saving = false;

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
        if (snapshot.hasError) {
          return Center(
            child: TextButton(
              onPressed: _reload,
              child: const Text('Could not load tasks. Retry'),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final tasks = snapshot.data!;
        return TaskListView(
          tasks: tasks,
          onToggleComplete: _saving
              ? null
              : (task) async {
                  setState(() => _saving = true);
                  try {
                    await widget.repository.completeTask(task.id);
                    if (mounted) _reload();
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Could not complete the task. Your saved task is retained.',
                          ),
                        ),
                      );
                    }
                  } finally {
                    if (mounted) setState(() => _saving = false);
                  }
                },
        );
      },
    );
  }
}
