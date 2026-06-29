import 'package:flutter/material.dart';

import 'core/bootstrap/sample_content_installer.dart';
import 'core/db/database.dart';
import 'core/theme/app_theme.dart';
import 'dev/demo_app.dart';
import 'dev/demo_services.dart';
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
  final db = CourrierDatabase();
  await const SampleContentInstaller().installIfMissing(db);
  runApp(CourrierApp(database: db));
}

class CourrierApp extends StatelessWidget {
  const CourrierApp({this.database, super.key});

  /// Provided by `main()` so the M11 shell-wiring milestone can reach it
  /// without re-opening another CourrierDatabase. Tests + the legacy widget
  /// test path can omit it (the shell uses placeholders for module screens
  /// when no database is attached — see destinations.dart).
  final CourrierDatabase? database;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'courrier',
      debugShowCheckedModeBanner: false,
      theme: CourrierTheme.light(),
      darkTheme: CourrierTheme.dark(),
      home: const AppShell(),
    );
  }
}
