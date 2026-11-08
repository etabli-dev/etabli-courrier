import 'package:courrier/core/db/database.dart';
import 'package:courrier/core/lock/app_security.dart';
import 'package:courrier/core/platform/platform_capabilities.dart';
import 'package:courrier/core/settings/about_info.dart';
import 'package:courrier/core/theme/app_theme.dart';
import 'package:courrier/modules/reminders/reminders_screen.dart';
import 'package:courrier/modules/reminders/scheduler/notification_scheduler.dart';
import 'package:courrier/modules/reminders/scheduler/reminder_rearm_service.dart';
import 'package:courrier/modules/shell/settings/settings_screen.dart';
import 'package:courrier/shell/destinations.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _UntouchableScheduler implements NotificationScheduler {
  int calls = 0;

  Never _fail() {
    calls++;
    throw StateError('notification plugin must not be used here');
  }

  @override
  Future<void> initialize() async => _fail();

  @override
  Future<bool> hasPermission() async => _fail();

  @override
  Future<bool> requestPermission() async => _fail();

  @override
  Future<void> schedule(ScheduledNotification notification) async => _fail();

  @override
  Future<void> cancel(int id) async => _fail();

  @override
  Future<void> cancelAll() async => _fail();

  @override
  Future<List<int>> scheduledIds() async => _fail();
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('capability matrix matches the plugin support per platform', () {
    const expected = {
      TargetPlatform.android: (auth: true, reminders: true),
      TargetPlatform.iOS: (auth: true, reminders: true),
      TargetPlatform.macOS: (auth: true, reminders: true),
      TargetPlatform.windows: (auth: true, reminders: false),
      TargetPlatform.linux: (auth: false, reminders: false),
    };
    for (final entry in expected.entries) {
      debugDefaultTargetPlatformOverride = entry.key;
      expect(
        PlatformCapabilities.deviceAuthentication,
        entry.value.auth,
        reason: '${entry.key}',
      );
      expect(
        PlatformCapabilities.scheduledReminders,
        entry.value.reminders,
        reason: '${entry.key}',
      );
    }
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(PlatformCapabilities.buildName, 'the Linux build');
  });

  test('unlock fails closed without device authentication', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    expect(await AppSecurity.unlock(), isFalse);
    expect(AppSecurity.authenticating, isFalse);
  });

  testWidgets('app lock switch is disabled and explained when unavailable', (
    tester,
  ) async {
    var toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(
          body: SettingsScreen(
            about: AboutInfo.current(),
            lockEnabled: false,
            onToggleLock: (_) => toggled = true,
            onExport: () {},
            onImport: () {},
            lockUnavailableReason: 'Not available here.',
          ),
        ),
      ),
    );
    expect(find.text('Not available here.'), findsOneWidget);
    final tile = tester.widget<SwitchListTile>(find.byType(SwitchListTile));
    expect(tile.onChanged, isNull);
    await tester.tap(find.byType(SwitchListTile));
    expect(toggled, isFalse);
  });

  testWidgets('reminders list due items without the notification plugin', (
    tester,
  ) async {
    final db = CourrierDatabase.forTesting(NativeDatabase.memory());
    final scheduler = _UntouchableScheduler();
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(
          body: RemindersScreen(
            scheduler: scheduler,
            rearmService: ReminderRearmService(db: db, scheduler: scheduler),
            unavailableReason: 'No notifications here.',
          ),
        ),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text('Reminder notifications unavailable'), findsOneWidget);
    expect(find.text('No notifications here.'), findsOneWidget);
    expect(find.text('Allow notifications'), findsNothing);
    expect(find.text('Nothing scheduled.'), findsOneWidget);
    await tester.tap(find.text('Reload'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text('Nothing scheduled.'), findsOneWidget);
    expect(scheduler.calls, 0);
    await db.close();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Linux shell routes reminders to the unavailable fallback', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    final db = CourrierDatabase.forTesting(NativeDatabase.memory());
    final reminders = moduleDestinations(
      db,
    ).firstWhere((d) => d.label == 'reminders');
    await tester.pumpWidget(
      MaterialApp(
        theme: CourrierTheme.light(),
        home: Scaffold(body: Builder(builder: reminders.builder)),
      ),
    );
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(find.text('Reminder notifications unavailable'), findsOneWidget);
    expect(find.textContaining('the Linux build'), findsOneWidget);
    expect(
      find.text('Could not load reminders. Please try Reload.'),
      findsNothing,
    );
    await db.close();
    await tester.pumpWidget(const SizedBox());
    debugDefaultTargetPlatformOverride = null;
  });
}
