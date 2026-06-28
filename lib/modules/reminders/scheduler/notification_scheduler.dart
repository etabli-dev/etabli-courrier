import 'package:meta/meta.dart';

// Platform-agnostic scheduling surface. The real impl wraps
// flutter_local_notifications; tests drive the in-memory FakeScheduler.

@immutable
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.fireAt,
    this.label,
    this.vibrate = true,
    this.sound = true,
    this.weekdaysOfRecurrence = const <int>[],
  });

  final int id;
  final String title;
  final String body;
  final DateTime fireAt;
  final String? label;
  final bool vibrate;
  final bool sound;

  /// 0-empty → one-shot. Non-empty → fires every week on these weekdays
  /// (DateTime.monday..DateTime.sunday).
  final List<int> weekdaysOfRecurrence;

  bool get isRecurring => weekdaysOfRecurrence.isNotEmpty;
}

abstract class NotificationScheduler {
  Future<void> initialize();

  /// Whether the OS-level permission to fire notifications has been granted.
  /// On platforms that don't have a runtime permission, returns `true`.
  Future<bool> hasPermission();

  /// Request OS-level permission. Returns the final granted state.
  Future<bool> requestPermission();

  Future<void> schedule(ScheduledNotification notification);

  Future<void> cancel(int id);

  Future<void> cancelAll();

  /// What's currently scheduled — used by ReminderRearmService to diff against
  /// the database expectation on cold start.
  Future<List<int>> scheduledIds();
}
