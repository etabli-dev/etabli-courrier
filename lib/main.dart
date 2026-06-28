import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'shell/app_shell.dart';

void main() => runApp(const CourrierApp());

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
