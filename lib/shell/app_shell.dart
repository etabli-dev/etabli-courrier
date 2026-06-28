import 'package:flutter/material.dart';

import 'destinations.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final destination = kModuleDestinations[_index];
    final media = MediaQuery.of(context);
    final useRail = media.size.width >= 720;

    final body = Builder(builder: destination.builder);

    if (useRail) {
      return Scaffold(
        appBar: _shellAppBar(destination.label),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: _onSelected,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in kModuleDestinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: _shellAppBar(destination.label),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _onSelected,
        destinations: [
          for (final d in kModuleDestinations)
            NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }

  void _onSelected(int i) => setState(() => _index = i);

  PreferredSizeWidget _shellAppBar(String label) {
    return AppBar(title: Text('courrier · $label'), centerTitle: false);
  }
}
