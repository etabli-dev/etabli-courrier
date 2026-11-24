import 'package:flutter/material.dart';

import '../../../core/settings/about_info.dart';
import '../../../core/settings/appearance_controller.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/l10n.dart';
import 'appearance_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.about,
    required this.lockEnabled,
    required this.onToggleLock,
    required this.onExport,
    required this.onImport,
    this.lockUnavailableReason,
    super.key,
  });

  final AboutInfo about;
  final bool lockEnabled;
  final ValueChanged<bool> onToggleLock;
  final VoidCallback onExport;
  final VoidCallback onImport;

  /// Disables the app-lock switch and explains why when non-null.
  final String? lockUnavailableReason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final appearance = AppearanceScope.maybeOf(context);
    return ListView(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      children: [
        Text(l10n.settingsTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: CourrierTokens.space5),
        if (appearance != null) ...[
          _SectionTitle(label: l10n.settingsAppearance),
          AppearanceSection(controller: appearance),
          const SizedBox(height: CourrierTokens.space5),
        ],
        _SectionTitle(label: l10n.settingsSecurity),
        Semantics(
          label: l10n.settingsLockToggle,
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: lockEnabled,
            onChanged: lockUnavailableReason == null ? onToggleLock : null,
            title: Text(
              l10n.settingsLockTitle,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              lockUnavailableReason ?? l10n.settingsLockSubtitle,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: CourrierTokens.space5),
        _SectionTitle(label: l10n.settingsExportImport),
        Row(
          children: [
            Semantics(
              button: true,
              label: l10n.settingsExportLabel,
              child: FilledButton.tonalIcon(
                onPressed: onExport,
                icon: const Icon(Icons.download_outlined),
                label: Text(l10n.settingsExport, maxLines: 1, softWrap: false),
              ),
            ),
            const SizedBox(width: CourrierTokens.space3),
            Semantics(
              button: true,
              label: l10n.settingsImportLabel,
              child: FilledButton.tonalIcon(
                onPressed: onImport,
                icon: const Icon(Icons.upload_outlined),
                label: Text(l10n.settingsImport, maxLines: 1, softWrap: false),
              ),
            ),
          ],
        ),
        const SizedBox(height: CourrierTokens.space5),
        _SectionTitle(label: l10n.settingsAbout),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsVersion, style: theme.textTheme.bodyLarge),
          subtitle: Text(about.versionLabel, style: theme.textTheme.bodySmall),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsSupport, style: theme.textTheme.bodyLarge),
          subtitle: SelectableText(
            '${about.fundingLabel} · ${about.fundingUrl}',
            style: theme.textTheme.bodySmall,
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsDocs, style: theme.textTheme.bodyLarge),
          subtitle: Text(about.docsUrl, style: theme.textTheme.bodySmall),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.description_outlined),
          title: Text(l10n.settingsLicenses),
          onTap: () => showLicensePage(
            context: context,
            applicationName: 'Établi Courrier',
            applicationVersion: about.versionLabel,
            applicationLegalese:
                'Copyright 2026 R. Heller. AGPL-3.0-only.\nSource and distribution notices: https://github.com/etabli-dev/etabli-courrier',
          ),
        ),
        const SizedBox(height: CourrierTokens.space5),
        Text(l10n.settingsFooter, style: theme.textTheme.bodySmall),
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
