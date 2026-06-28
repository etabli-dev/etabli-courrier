import 'package:flutter/material.dart';

import '../core/db/database.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/tokens.dart';
import '../modules/calendar/calendar_screen.dart';
import '../modules/contacts/contacts_screen.dart';
import '../modules/feeds/data/feed_repository.dart';
import '../modules/feeds/ui/feed_subscription_list.dart';
import '../modules/mail/data/mail_repository.dart';
import '../modules/mail/ui/thread_list_view.dart';
import '../modules/notes/notes_screen.dart';
import '../modules/tasks/tasks_screen.dart';
import 'demo_services.dart';

// Dev-only shell wired to the in-memory DemoServices. Used by:
//   * M13 Maestro screenshot harness (light + dark capture)
//   * M14 bundled sample-content path
//
// Production users never see this — `main()` only routes here when
// --dart-define=COURRIER_DEMO_BOOT=true. The route keys here match the keys
// the Maestro flows under `.maestro/flows/` look for.

class DemoApp extends StatefulWidget {
  const DemoApp({required this.services, super.key});

  static const String darkModeFlag = 'COURRIER_DEMO_DARK';

  final DemoServices services;

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  int _index = 0;

  late final List<_DemoTab> _tabs = [
    _DemoTab(
      label: 'mail',
      icon: Icons.mail_outline,
      key: const ValueKey('demo-mail-tab'),
      builder: (_) => _DemoMailScreen(repository: widget.services.mail),
    ),
    _DemoTab(
      label: 'calendar',
      icon: Icons.calendar_today_outlined,
      key: const ValueKey('demo-calendar-tab'),
      builder: (_) => CalendarScreen(repository: widget.services.calendar),
    ),
    _DemoTab(
      label: 'contacts',
      icon: Icons.person_outline,
      key: const ValueKey('demo-contacts-tab'),
      builder: (_) => ContactsScreen(repository: widget.services.contacts),
    ),
    _DemoTab(
      label: 'tasks',
      icon: Icons.check_box_outlined,
      key: const ValueKey('demo-tasks-tab'),
      builder: (_) => TasksScreen(repository: widget.services.tasks),
    ),
    _DemoTab(
      label: 'notes',
      icon: Icons.notes,
      key: const ValueKey('demo-notes-tab'),
      builder: (_) => NotesScreen(repository: widget.services.notes),
    ),
    _DemoTab(
      label: 'feeds',
      icon: Icons.rss_feed,
      key: const ValueKey('demo-feeds-tab'),
      builder: (_) => _DemoFeedsScreen(repository: widget.services.feeds),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const darkMode = bool.fromEnvironment(DemoApp.darkModeFlag);
    final tab = _tabs[_index];
    return MaterialApp(
      title: 'courrier — demo',
      debugShowCheckedModeBanner: false,
      theme: CourrierTheme.light(),
      darkTheme: CourrierTheme.dark(),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text('courrier · ${tab.label}'),
          centerTitle: false,
        ),
        body: tab.builder(context),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (final t in _tabs)
              NavigationDestination(
                key: t.key,
                icon: Icon(t.icon),
                label: t.label,
              ),
          ],
        ),
      ),
    );
  }
}

class _DemoTab {
  const _DemoTab({
    required this.label,
    required this.icon,
    required this.key,
    required this.builder,
  });
  final String label;
  final IconData icon;
  final Key key;
  final WidgetBuilder builder;
}

// Mail demo screen — surfaces the thread list against the demo backend so
// Maestro can capture inbox + thread.
class _DemoMailScreen extends StatefulWidget {
  const _DemoMailScreen({required this.repository});

  final MailRepository repository;

  @override
  State<_DemoMailScreen> createState() => _DemoMailScreenState();
}

class _DemoMailScreenState extends State<_DemoMailScreen> {
  late Future<List<MailThread>> _threads;

  @override
  void initState() {
    super.initState();
    _threads = widget.repository.threadsIn('INBOX');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MailThread>>(
      future: _threads,
      builder: (context, snapshot) {
        final data = snapshot.data ?? const <MailThread>[];
        return ThreadListView(threads: data);
      },
    );
  }
}

// Feeds demo screen — surfaces the subscription list against the in-memory
// repository.
class _DemoFeedsScreen extends StatelessWidget {
  const _DemoFeedsScreen({required this.repository});

  final FeedRepository repository;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FeedSubscription>>(
      future: repository.listSubscriptions(),
      builder: (context, snapshot) {
        final subs = snapshot.data ?? const <FeedSubscription>[];
        return FeedSubscriptionList(
          subscriptions: subs,
          unreadCounts: const {},
        );
      },
    );
  }
}

// Public helper so test code can render any single tab in isolation.
Widget demoTabFor(String label, DemoServices services) {
  switch (label) {
    case 'mail':
      return _DemoMailScreen(repository: services.mail);
    case 'calendar':
      return CalendarScreen(repository: services.calendar);
    case 'contacts':
      return ContactsScreen(repository: services.contacts);
    case 'tasks':
      return TasksScreen(repository: services.tasks);
    case 'notes':
      return NotesScreen(repository: services.notes);
    case 'feeds':
      return _DemoFeedsScreen(repository: services.feeds);
  }
  return const SizedBox.shrink(key: ValueKey('demo-unknown'));
}

// Token-only constant for the M0 borderWidth check — keeps the analyzer happy
// while exposing nothing extra at runtime.
const double demoBorderWidth = CourrierTokens.borderWidth;
