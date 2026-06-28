import 'package:flutter/material.dart';

import 'scheduler/notification_scheduler.dart';
import 'scheduler/reminder_rearm_service.dart';
import 'ui/reminders_list_view.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({
    required this.scheduler,
    required this.rearmService,
    super.key,
  });

  final NotificationScheduler scheduler;
  final ReminderRearmService rearmService;

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _hasPermission = true;
  final List<ScheduledNotification> _upcoming = const <ScheduledNotification>[];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    final granted = await widget.scheduler.hasPermission();
    if (!mounted) {
      return;
    }
    setState(() => _hasPermission = granted);
    // M5 surfaces a one-line summary instead of the full list — the scheduler
    // doesn't yet round-trip full ScheduledNotification objects. M11 polish
    // wires a notifications database for richer surfacing.
  }

  Future<void> _requestPermission() async {
    await widget.scheduler.requestPermission();
    await _refresh();
  }

  Future<void> _reload() async {
    await widget.rearmService.rearmAll();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RemindersListView(
      reminders: _upcoming,
      hasPermission: _hasPermission,
      onRequestPermission: _requestPermission,
      onReload: _reload,
    );
  }
}
