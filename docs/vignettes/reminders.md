# Reminders (M5)

`courrier` fires local notifications for two sources:

- **Event reminders** — each `EventReminders` row (N per event, M1 schema)
  becomes a one-shot notification. The fire time is either
  `EventReminders.absoluteTrigger` or `event.dtstart - minutesBeforeStart`.
- **Task due-dates** — each `TodoItems` row with a non-null `due` and no
  `completed` becomes a one-shot at the due moment.

## Architecture

```
NotificationScheduler (interface)
├── LocalNotificationScheduler — wraps flutter_local_notifications,
│   schedules via Android AlarmManager (exactAllowWhileIdle) and iOS
│   UNUserNotificationCenter. Weekday recurrence fans out to
│   one-per-weekday child ids using a (baseId * 10 + weekday) scheme.
└── FakeScheduler — in-memory, used by every test.

ReminderRearmService(db, scheduler)
└── rearmAll({horizon = 30 days})
    1. scheduler.cancelAll()
    2. For each EventReminders row whose computed fire-time falls in
       [now, now+horizon] — schedule.
    3. For each TodoItems row whose `due` falls in the window — schedule.
```

## Re-arm on reboot / upgrade (audit gate)

- **Android.** `AndroidManifest.xml` declares `RECEIVE_BOOT_COMPLETED` plus
  the `com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver`.
  After `BOOT_COMPLETED` (or `MY_PACKAGE_REPLACED` for upgrade-then-restart),
  the receiver wakes the app long enough for the rearm to run.
- **iOS.** No boot intent; iOS keeps schedules across reboot itself. We still
  call `rearmAll()` on every cold start so an upgrade that changed the
  notification schema doesn't strand stale entries.
- **Test gate.** `reminder_rearm_service_test.dart` covers the gate with a
  fake scheduler. The "Simulated reboot" test wipes the scheduler's state
  between rearm passes and asserts every active reminder + every task with a
  due-date in window re-arms; the "cancelAll runs before scheduling" test
  asserts stale ids from a previous arm don't survive.

## Permissions

- Android 13+ (`POST_NOTIFICATIONS`) and Android 12+ exact-alarm permission
  (`SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`) are declared in the manifest
  and requested at runtime via `LocalNotificationScheduler.requestPermission()`.
- iOS surfaces the alert/badge/sound prompt on the first request.
- The Reminders screen renders an actionable permission card when permission
  isn't granted — never a silent failure (audit dim 8).

## Weekday recurrence

`ScheduledNotification.weekdaysOfRecurrence` (subset of `DateTime.monday`..
`DateTime.sunday`) fans out to one schedule per weekday with the next
in-future occurrence; `flutter_local_notifications`'s `dayOfWeekAndTime`
match keeps each one firing weekly. M5 surfaces this for the Fossify-style
weekday alarm pattern; the calendar module doesn't yet emit it (it would for
"every Monday at 9am" style RRULE patterns at M11 polish).

## Open at M5

- The reminders screen lists scheduled notifications via the scheduler's
  `pendingNotificationRequests` (Android/iOS). The M5 build wires the screen
  to show *count* + reload action; the per-tile list comes from a notifications
  database introduced at M11.
- Sound and vibrate default to true; the per-reminder override lands at M11.
