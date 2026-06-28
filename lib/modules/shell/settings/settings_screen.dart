import 'package:flutter/material.dart';

import '../../../core/settings/about_info.dart';
import '../../../core/theme/tokens.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.about,
    required this.lockEnabled,
    required this.onToggleLock,
    required this.onExport,
    required this.onImport,
    super.key,
  });

  final AboutInfo about;
  final bool lockEnabled;
  final ValueChanged<bool> onToggleLock;
  final VoidCallback onExport;
  final VoidCallback onImport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      children: [
        Text('Settings', style: theme.textTheme.titleLarge),
        const SizedBox(height: CourrierTokens.space5),
        const _SectionTitle(label: 'Security'),
        Semantics(
          label: 'Toggle app lock',
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: lockEnabled,
            onChanged: onToggleLock,
            title: Text(
              'App lock (PIN / biometric)',
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              'Require unlocking when courrier resumes from background.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: CourrierTokens.space5),
        const _SectionTitle(label: 'Settings export / import'),
        Row(
          children: [
            Semantics(
              button: true,
              label: 'Export settings as JSON',
              child: FilledButton.tonalIcon(
                onPressed: onExport,
                icon: const Icon(Icons.download_outlined),
                label: const Text('Export'),
              ),
            ),
            const SizedBox(width: CourrierTokens.space3),
            Semantics(
              button: true,
              label: 'Import settings from JSON',
              child: FilledButton.tonalIcon(
                onPressed: onImport,
                icon: const Icon(Icons.upload_outlined),
                label: const Text('Import'),
              ),
            ),
          ],
        ),
        const SizedBox(height: CourrierTokens.space5),
        const _SectionTitle(label: 'About'),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Version', style: theme.textTheme.bodyLarge),
          subtitle: Text(about.versionLabel, style: theme.textTheme.bodySmall),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Support development', style: theme.textTheme.bodyLarge),
          subtitle: Text(about.fundingLabel, style: theme.textTheme.bodySmall),
          trailing: const Icon(Icons.open_in_new, size: 16),
        ),
        const SizedBox(height: CourrierTokens.space5),
        Text(
          'courrier is part of the Établi Suite. Apache-2.0.',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CourrierTokens.space2),
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
