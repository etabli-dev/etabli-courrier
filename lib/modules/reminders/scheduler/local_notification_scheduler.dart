import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler.dart';

// Real scheduler backed by flutter_local_notifications.
//
// Android: uses AlarmManager (exact alarms). Notifications survive reboot
//   provided the app declared RECEIVE_BOOT_COMPLETED and the package's
//   ScheduledNotificationBootReceiver is in the manifest (see AndroidManifest.xml).
//   After API 31 (Android 12) we additionally need SCHEDULE_EXACT_ALARM /
//   user consent for exact precision; otherwise use inexact alarms.
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
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
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
    if (notification.id < 0 || notification.id > 268435455) {
      throw ArgumentError('Notification ID is outside the supported range.');
    }
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final exact =
        !Platform.isAndroid ||
        (await android?.canScheduleExactNotifications() ?? false);
    final mode = exact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
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
        final nextFire = nextWeeklyOccurrence(
          tzTime,
          weekday,
          tz.TZDateTime.now(tz.local),
        );
        await _plugin.zonedSchedule(
          id: id,
          title: notification.title,
          body: notification.body,
          scheduledDate: nextFire,
          notificationDetails: details,
          androidScheduleMode: mode,
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
      androidScheduleMode: mode,
    );
  }

  @override
  Future<void> cancel(int id) async {
    // Cancel both the one-shot id and every weekday variant.
    await _plugin.cancel(id: id);
    if (id < 0) return;
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
  int _weekdayChildId(int baseId, int weekday) => -(baseId * 8 + weekday);
}

/// Calendar arithmetic preserves the requested wall time through DST changes.
tz.TZDateTime nextWeeklyOccurrence(
  tz.TZDateTime sample,
  int weekday,
  tz.TZDateTime now,
) {
  if (weekday < 1 || weekday > 7) throw ArgumentError.value(weekday, 'weekday');
  final localNow = tz.TZDateTime.from(now, sample.location);
  final first = sample.isAfter(localNow) ? sample : localNow;
  final days = (weekday - first.weekday + 7) % 7;
  var result = tz.TZDateTime(
    sample.location,
    first.year,
    first.month,
    first.day + days,
    sample.hour,
    sample.minute,
    sample.second,
  );
  if (!result.isAfter(localNow) || result.isBefore(sample)) {
    result = tz.TZDateTime(
      sample.location,
      result.year,
      result.month,
      result.day + 7,
      sample.hour,
      sample.minute,
      sample.second,
    );
  }
  return result;
}
