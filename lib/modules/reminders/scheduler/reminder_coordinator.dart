import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../core/db/database.dart';
import 'notification_scheduler.dart';
import 'reminder_rearm_service.dart';

/// Keeps reminders current without asking for permission during app startup.
class ReminderCoordinator extends ChangeNotifier with WidgetsBindingObserver {
  ReminderCoordinator({required this.db, required this.scheduler})
    : service = ReminderRearmService(
        db: db,
        scheduler: scheduler,
        maximumScheduled:
            defaultTargetPlatform == TargetPlatform.iOS ||
                defaultTargetPlatform == TargetPlatform.macOS
            ? 60
            : null,
      );

  final CourrierDatabase db;
  final NotificationScheduler scheduler;
  final ReminderRearmService service;
  String? error;
  StreamSubscription<Set<TableUpdate>>? _changes;
  Timer? _debounce;
  Future<void>? _inFlight;
  bool _repeat = false;
  bool _disposed = false;
  bool _started = false;

  void start() {
    if (_started || _disposed) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _changes = db
        .tableUpdates(
          TableUpdateQuery.onAllTables([
            db.calendarEvents,
            db.eventReminders,
            db.todoItems,
          ]),
        )
        .listen((_) {
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 200), refresh);
        });
    unawaited(refresh());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(refresh());
  }

  Future<void> refresh() {
    if (_disposed) return Future.value();
    if (_inFlight != null) {
      _repeat = true;
      return _inFlight!;
    }
    return _inFlight = _refresh().whenComplete(() => _inFlight = null);
  }

  Future<void> _refresh() async {
    do {
      _repeat = false;
      try {
        // Re-resolve the device time zone on resume as well as cold start.
        await scheduler.initialize();
        if (_disposed) return;
        if (await scheduler.hasPermission()) {
          if (_disposed) return;
          await service.rearmAll();
        }
        error = null;
      } catch (_) {
        error =
            'Reminders could not refresh. Open Reminders and choose Reload.';
      }
      if (!_disposed) notifyListeners();
    } while (_repeat && !_disposed);
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    _changes?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
