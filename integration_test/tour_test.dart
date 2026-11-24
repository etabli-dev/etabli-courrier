// Screenshot tour on a simulator or device: every module, the drawer, accounts, settings and the main
// dialogs in English and German, plus dark mode with the yellow accent. Run it with
//
//   flutter drive --driver=test_driver/integration_test.dart \
//     --target=integration_test/tour_test.dart -d <device>
//
// The screenshots land in build/tour/ (git-ignored).

import 'package:courrier/main.dart' as app;
import 'package:courrier/shell/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('screenshot tour', (tester) async {
    await app.main();

    Future<void> settle([int ms = 700]) async {
      for (var t = 0; t < ms; t += 50) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    for (var i = 0; i < 120 && find.byType(AppShell).evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    await settle(1500);
    final view = tester.view;
    final device = view.physicalSize.width / view.devicePixelRatio >= 600
        ? 'ipad'
        : 'phone';
    final wide = device == 'ipad';
    var lang = 'en';
    var n = 0;

    Future<void> shot(String name) async {
      await settle();
      n++;
      final id = '$device-$lang-${n.toString().padLeft(2, '0')}-$name';
      await binding.takeScreenshot(id);
      debugPrint('TOUR: screenshot $id');
    }

    Future<void> tap(Finder finder) async {
      await tester.tap(finder.hitTestable().first);
      await settle();
    }

    Future<void> back() async {
      await tap(find.byType(BackButton));
    }

    Future<void> dismiss() async {
      await tester.tapAt(const Offset(8, 300));
      await settle();
    }

    /// Opens a module: phones reach the last three through the "more" drawer.
    Future<void> module(IconData icon) async {
      if (!wide &&
          {
            Icons.check_box_outlined,
            Icons.alarm,
            Icons.rss_feed,
          }.contains(icon)) {
        await tap(find.byIcon(Icons.more_horiz));
      }
      await tap(find.byIcon(icon));
    }

    Future<void> openSettings() => tap(find.byIcon(Icons.settings_outlined));

    Future<void> setLanguage(String option) async {
      await openSettings();
      await tap(find.byKey(const ValueKey('settings.appearance.language')));
      await tap(find.text(option));
      await back();
    }

    Future<void> setLook(int mode, String accent) async {
      await openSettings();
      await tap(
        find
            .descendant(
              of: find.byKey(const ValueKey('settings.appearance.mode')),
              matching: find.byType(Text),
            )
            .at(mode),
      );
      await tap(find.byKey(ValueKey('settings.appearance.accent.$accent')));
      await back();
    }

    Future<void> screens() async {
      await module(Icons.mail_outline);
      await shot('mail');
      await module(Icons.calendar_today_outlined);
      await shot('calendar');
      final segments = find.descendant(
        of: find.byWidgetPredicate((w) => w is SegmentedButton),
        matching: find.byType(Text),
      );
      if (segments.evaluate().length > 1) {
        await tap(segments.at(1));
        await shot('calendar-other-view');
        await tap(segments.at(0));
      }
      await module(Icons.person_outline);
      await shot('contacts');
      await module(Icons.notes);
      await shot('notes');
      await tap(find.text('Getting started'));
      await shot('note-editor');
      await back();
      await tap(find.byIcon(Icons.add));
      await shot('note-new');
      await back();
      await shot('note-new-back');
      if (find.byType(AlertDialog).evaluate().isNotEmpty) {
        await tap(
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextButton),
          ),
        );
      }
      if (!wide) {
        await tap(find.byIcon(Icons.more_horiz));
        await shot('drawer');
        await dismiss();
      }
      await module(Icons.check_box_outlined);
      await shot('tasks');
      await module(Icons.alarm);
      await shot('reminders');
      await module(Icons.rss_feed);
      await shot('feeds');
      await tap(find.byIcon(Icons.add));
      await shot('dialog-add-feed');
      await dismiss();
      await tap(find.text('courrier release notes'));
      await shot('feed-items');
      await tap(find.byIcon(Icons.delete_outline));
      await shot('dialog-remove-feed');
      await tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextButton),
        ),
      );
      await tap(find.byIcon(Icons.manage_accounts_outlined));
      await shot('accounts');
      await tap(find.byIcon(Icons.cloud_outlined));
      await shot('accounts-nextcloud');
      await back();
      await tap(find.byIcon(Icons.mail_outline).last);
      await shot('accounts-imap');
      await back();
      await back();
      await openSettings();
      await shot('settings');
      await tap(find.byKey(const ValueKey('settings.appearance.language')));
      await shot('language-menu');
      await dismiss();
      await tester.drag(find.byType(ListView).last, const Offset(0, -900));
      await shot('settings-bottom');
      await back();
    }

    await setLanguage('English');
    await setLook(1, 'coderBlue');
    await screens();
    await setLook(2, 'yellow');
    await openSettings();
    await shot('dark-yellow-settings');
    await back();
    await module(Icons.calendar_today_outlined);
    await shot('dark-yellow-calendar');
    if (!wide) {
      await tap(find.byIcon(Icons.more_horiz));
      await shot('dark-yellow-drawer');
      await dismiss();
    }
    await setLook(1, 'orange');
    await module(Icons.notes);
    await shot('light-orange-notes');

    await setLanguage('Deutsch');
    lang = 'de';
    n = 0;
    await setLook(1, 'coderBlue');
    await screens();
    await setLook(2, 'purple');
    await module(Icons.calendar_today_outlined);
    await shot('dark-purple-calendar');
    await setLook(0, 'coderBlue');
  });
}
