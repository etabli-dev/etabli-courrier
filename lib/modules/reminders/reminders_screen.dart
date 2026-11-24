import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import 'scheduler/notification_scheduler.dart';
import 'scheduler/reminder_rearm_service.dart';
import 'ui/reminders_list_view.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({
    required this.scheduler,
    required this.rearmService,
    this.unavailableReason,
    this.refreshSchedule,
    super.key,
  });

  final NotificationScheduler scheduler;
  final ReminderRearmService rearmService;
  final Future<void> Function()? refreshSchedule;

  /// Set where system notifications cannot be scheduled. The screen then
  /// lists what is due without touching the notification plugin.
  final String? unavailableReason;

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

enum _RemindersError { load, enable, reload }

class _RemindersScreenState extends State<RemindersScreen> {
  bool _hasPermission = false;
  bool _loading = true;
  _RemindersError? _error;
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
          _error = _RemindersError.load;
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    try {
      final granted = await widget.scheduler.requestPermission();
      if (granted) {
        if (widget.refreshSchedule != null) {
          await widget.refreshSchedule!();
        } else {
          await widget.rearmService.rearmAll();
        }
      }
      await _refresh();
    } catch (_) {
      if (mounted) {
        setState(() => _error = _RemindersError.enable);
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
          if (widget.refreshSchedule != null) {
            await widget.refreshSchedule!();
          } else {
            await widget.rearmService.rearmAll();
          }
        }
      }
      await _refresh();
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = _RemindersError.reload;
        });
      }
    }
  }

  String _errorText(AppLocalizations l10n, _RemindersError error) =>
      switch (error) {
        _RemindersError.load => l10n.remindersLoadFailed,
        _RemindersError.enable => l10n.remindersEnableFailed,
        _RemindersError.reload => l10n.remindersReloadFailed,
      };

  @override
  Widget build(BuildContext context) {
    final error = _error;
    return Column(
      children: [
        if (_loading) const LinearProgressIndicator(),
        if (error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(_errorText(context.l10n, error)),
          ),
        Expanded(
          child: RemindersListView(
            reminders: _upcoming,
            scheduleLimit: widget.rearmService.maximumScheduled,
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
