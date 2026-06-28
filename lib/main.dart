import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'dev/demo_app.dart';
import 'dev/demo_services.dart';
import 'shell/app_shell.dart';

// `--dart-define=COURRIER_DEMO_BOOT=true` routes startup into the M13/M14
// demo shell wired to in-memory data. Production builds set this to false
// (the default) and reach the regular AppShell.
const bool _demoBoot = bool.fromEnvironment('COURRIER_DEMO_BOOT');

Future<void> main() async {
  if (_demoBoot) {
    WidgetsFlutterBinding.ensureInitialized();
    final services = await DemoServices.bootInMemory();
    runApp(DemoApp(services: services));
    return;
  }
  runApp(const CourrierApp());
}

class CourrierApp extends StatelessWidget {
  const CourrierApp({super.key});

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
