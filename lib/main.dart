import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/bootstrap/sample_content_installer.dart';
import 'core/db/database.dart';
import 'core/lock/app_security.dart';
import 'core/platform/platform_capabilities.dart';
import 'core/settings/appearance_controller.dart';
import 'core/theme/app_theme.dart';
import 'dev/demo_app.dart';
import 'dev/demo_services.dart';
import 'l10n/l10n.dart';
import 'modules/reminders/scheduler/local_notification_scheduler.dart';
import 'modules/reminders/scheduler/reminder_coordinator.dart';
import 'shell/app_shell.dart';

// `--dart-define=COURRIER_DEMO_BOOT=true` routes startup into the M13/M14
// demo shell wired to in-memory data. Production builds set this to false
// (the default) and reach the regular AppShell after the sample-content
// installer seeds the first-launch experience.
const bool _demoBoot = bool.fromEnvironment('COURRIER_DEMO_BOOT');

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  if (_demoBoot) {
    // The Maestro screenshot harness relies on the platform accessibility
    // tree to find widgets by text. Flutter only wires that tree when an
    // a11y service connects; Maestro never triggers one. Force-enabling
    // semantics on the demo boot path makes every label / list cell
    // discoverable to `maestro test` without leaking the cost into
    // production builds (this binary never ships with COURRIER_DEMO_BOOT).
    binding.ensureSemantics();
    final services = await DemoServices.bootInMemory();
    runApp(DemoApp(services: services));
    return;
  }
  runApp(const CourrierBootstrap());
}

class CourrierApp extends StatefulWidget {
  const CourrierApp({
    required this.database,
    this.reminders,
    this.appearance,
    super.key,
  });

  final CourrierDatabase database;
  final ReminderCoordinator? reminders;

  /// The stored language, mode and accent; defaults only when null (tests).
  final AppearanceController? appearance;

  @override
  State<CourrierApp> createState() => _CourrierAppState();
}

class _CourrierAppState extends State<CourrierApp> {
  late final AppearanceController _appearance =
      widget.appearance ?? AppearanceController.memory();

  @override
  Widget build(BuildContext context) => AppearanceScope(
    controller: _appearance,
    child: ListenableBuilder(
      listenable: _appearance,
      builder: (context, _) => MaterialApp(
        title: 'courrier',
        builder: (context, child) {
          // Texts made outside widgets (services, notifications) follow the same language.
          L10n.update(Localizations.localeOf(context));
          return AppLockHost(child: child ?? const SizedBox.shrink());
        },
        debugShowCheckedModeBanner: false,
        theme: CourrierTheme.light(_appearance.accent),
        darkTheme: CourrierTheme.dark(_appearance.accent),
        themeMode: _appearance.mode.themeMode,
        locale: _appearance.language.locale,
        supportedLocales: appSupportedLocales,
        localizationsDelegates: courrierLocalizationsDelegates,
        home: AppShell(database: widget.database, reminders: widget.reminders),
      ),
    ),
  );
}

/// The app's and Flutter's own (Material, Cupertino, widgets) German and English strings.
const List<LocalizationsDelegate<Object>> courrierLocalizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

class CourrierBootstrap extends StatefulWidget {
  const CourrierBootstrap({super.key});
  @override
  State<CourrierBootstrap> createState() => _CourrierBootstrapState();
}

class _CourrierBootstrapState extends State<CourrierBootstrap> {
  CourrierDatabase? _database;
  ReminderCoordinator? _reminders;
  AppearanceController? _appearance;
  bool _ready = false;
  String? _error;
  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    setState(() => _error = null);
    try {
      _reminders?.dispose();
      _reminders = null;
      await _database?.close();
      _appearance ??= await AppearanceController.load();
      final db = _database = CourrierDatabase();
      await const SampleContentInstaller().installIfMissing(db);
      if (!mounted) return;
      if (PlatformCapabilities.scheduledReminders) {
        _reminders = ReminderCoordinator(
          db: db,
          scheduler: LocalNotificationScheduler(),
        );
      }
      setState(() => _ready = true);
    } catch (_) {
      if (mounted) setState(() => _error = L10n.current.bootDatabaseFailed);
    }
  }

  @override
  void dispose() {
    _reminders?.dispose();
    _database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _ready
      ? CourrierApp(
          database: _database!,
          reminders: _reminders,
          appearance: _appearance,
        )
      : MaterialApp(
          locale: _appearance?.language.locale,
          supportedLocales: appSupportedLocales,
          localizationsDelegates: courrierLocalizationsDelegates,
          builder: (context, child) {
            L10n.update(Localizations.localeOf(context));
            return child ?? const SizedBox.shrink();
          },
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _error == null
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Builder(
                            builder: (context) =>
                                Text(context.l10n.bootDatabaseFailed),
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _open,
                            child: Builder(
                              builder: (context) =>
                                  Text(context.l10n.commonRetry),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        );
}
