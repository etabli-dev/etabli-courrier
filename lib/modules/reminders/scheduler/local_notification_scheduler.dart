import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler.dart';

// Real scheduler backed by flutter_local_notifications.
//
// Android: uses AlarmManager (exact alarms). Notifications survive reboot
//   provided the app declared RECEIVE_BOOT_COMPLETED and the package's
//   ScheduledNotificationBootReceiver is in the manifest (see AndroidManifest.xml).
//   After API 31 (Android 12) we additionally need SCHEDULE_EXACT_ALARM /
//   USE_EXACT_ALARM to get to-the-minute precision.
// iOS:    uses UNUserNotificationCenter. Schedules survive reboot but if the
//   user hasn't opened the app in months iOS may garbage-collect them; we
//   re-arm on every cold start regardless.

class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const String _androidChannelId = 'courrier_reminders';
  static const String _androidChannelName = 'Reminders';
  static const String _androidChannelDescription =
      'Event reminders and task due-dates from courrier.';

  @override
  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const init = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );
    await _plugin.initialize(settings: init);

    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDescription,
        importance: Importance.high,
      ),
    );
  }

  @override
  Future<bool> hasPermission() async {
    if (Platform.isIOS) {
      final darwin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      final granted = await darwin?.checkPermissions();
      return granted?.isEnabled ?? false;
    }
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return await android?.areNotificationsEnabled() ?? false;
    }
    return true;
  }

  @override
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final darwin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      return await darwin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await android?.requestNotificationsPermission() ?? false;
      await android?.requestExactAlarmsPermission();
      return granted;
    }
    return true;
  }

  @override
  Future<void> schedule(ScheduledNotification notification) async {
    final tzTime = tz.TZDateTime.from(notification.fireAt, tz.local);
    final androidDetails = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDescription,
      importance: Importance.high,
      enableVibration: notification.vibrate,
      playSound: notification.sound,
    );
    final darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: notification.sound,
    );
    final details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    if (notification.isRecurring) {
      for (final weekday in notification.weekdaysOfRecurrence) {
        final id = _weekdayChildId(notification.id, weekday);
        final nextFire = _nextOccurrenceOnWeekday(tzTime, weekday);
        await _plugin.zonedSchedule(
          id: id,
          title: notification.title,
          body: notification.body,
          scheduledDate: nextFire,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
      return;
    }

    await _plugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: tzTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancel(int id) async {
    // Cancel both the one-shot id and every weekday variant.
    await _plugin.cancel(id: id);
    for (var w = DateTime.monday; w <= DateTime.sunday; w++) {
      await _plugin.cancel(id: _weekdayChildId(id, w));
    }
  }

  @override
  Future<void> cancelAll() => _plugin.cancelAll();

  @override
  Future<List<int>> scheduledIds() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.map((p) => p.id).toList(growable: false);
  }

  // Composite key so weekday recurrence doesn't collide with one-shot ids.
  int _weekdayChildId(int baseId, int weekday) => baseId * 10 + weekday;

  tz.TZDateTime _nextOccurrenceOnWeekday(tz.TZDateTime sample, int weekday) {
    var candidate = sample;
    while (candidate.weekday != weekday) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }
}
