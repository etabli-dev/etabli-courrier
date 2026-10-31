import 'package:flutter/material.dart';

import '../core/config/secrets_store.dart';
import '../core/db/database.dart';
import '../core/sync/account_services.dart';
import '../modules/accounts/accounts_screen.dart';
import '../modules/shell/settings/production_settings.dart';
import 'destinations.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.database, super.key});

  final CourrierDatabase database;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _phoneScaffold = GlobalKey<ScaffoldState>();
  final _secrets = SecretsStore();
  late final _services = AccountServices(
    db: widget.database,
    secrets: _secrets,
  );
  late final List<ModuleDestination> _destinations = moduleDestinations(
    widget.database,
    services: _services,
  );

  @override
  Widget build(BuildContext context) {
    final destination = _destinations[_index];
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
                for (final d in _destinations)
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

    const primary = [0, 1, 2, 5];
    final selectedPrimary = primary.indexOf(_index);
    return Scaffold(
      key: _phoneScaffold,
      appBar: _shellAppBar(destination.label),
      body: body,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(title: Text('Modules')),
              for (var i = 0; i < _destinations.length; i++)
                ListTile(
                  leading: Icon(_destinations[i].icon),
                  title: Text(_destinations[i].label),
                  selected: i == _index,
                  onTap: () {
                    Navigator.of(context).pop();
                    _onSelected(i);
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPrimary < 0 ? 4 : selectedPrimary,
        onDestinationSelected: (index) {
          if (index == 4) {
            _phoneScaffold.currentState?.openDrawer();
          } else {
            _onSelected(primary[index]);
          }
        },
        destinations: [
          for (final i in primary)
            NavigationDestination(
              icon: Icon(_destinations[i].icon),
              label: _destinations[i].label,
            ),
          const NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'more',
            tooltip: 'More modules',
          ),
        ],
      ),
    );
  }

  void _onSelected(int i) => setState(() => _index = i);

  PreferredSizeWidget _shellAppBar(String label) {
    return AppBar(
      title: Text('courrier · $label'),
      centerTitle: false,
      actions: [
        IconButton(
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ProductionSettings()),
          ),
        ),
        IconButton(
          tooltip: 'Accounts',
          icon: const Icon(Icons.manage_accounts_outlined),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => AccountsScreen(
                db: widget.database,
                services: _services,
                secrets: _secrets,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
