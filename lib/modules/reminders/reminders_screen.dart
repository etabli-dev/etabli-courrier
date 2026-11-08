import 'package:flutter/material.dart';

import 'scheduler/notification_scheduler.dart';
import 'scheduler/reminder_rearm_service.dart';
import 'ui/reminders_list_view.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({
    required this.scheduler,
    required this.rearmService,
    this.unavailableReason,
    super.key,
  });

  final NotificationScheduler scheduler;
  final ReminderRearmService rearmService;

  /// Set where system notifications cannot be scheduled. The screen then
  /// lists what is due without touching the notification plugin.
  final String? unavailableReason;

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  bool _hasPermission = false;
  bool _loading = true;
  String? _error;
  List<ScheduledNotification> _upcoming = const <ScheduledNotification>[];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final available = widget.unavailableReason == null;
      if (available) await widget.scheduler.initialize();
      final granted = available && await widget.scheduler.hasPermission();
      final upcoming = await widget.rearmService.upcoming();
      if (!mounted) return;
      setState(() {
        _hasPermission = granted;
        _upcoming = upcoming;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not load reminders. Please try Reload.';
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    try {
      final granted = await widget.scheduler.requestPermission();
      if (granted) await widget.rearmService.rearmAll();
      await _refresh();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Could not enable reminders. Check notification permissions.',
        );
      }
    }
  }

  Future<void> _reload() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      if (widget.unavailableReason == null) {
        await widget.scheduler.initialize();
        if (await widget.scheduler.hasPermission()) {
          await widget.rearmService.rearmAll();
        }
      }
      await _refresh();
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error =
              'Reload failed. Existing reminders have been retained where possible.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_loading) const LinearProgressIndicator(),
        if (_error != null)
          Padding(padding: const EdgeInsets.all(16), child: Text(_error!)),
        Expanded(
          child: RemindersListView(
            reminders: _upcoming,
            hasPermission: _hasPermission,
            onRequestPermission: _requestPermission,
            onReload: _loading ? null : _reload,
            unavailableReason: widget.unavailableReason,
          ),
        ),
      ],
    );
  }
}
