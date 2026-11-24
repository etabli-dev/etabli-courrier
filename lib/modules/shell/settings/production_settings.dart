import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/config/preferences_store.dart';
import '../../../core/lock/app_security.dart';
import '../../../core/platform/platform_capabilities.dart';
import '../../../core/settings/about_info.dart';
import '../../../core/settings/settings_io.dart';
import '../../../l10n/l10n.dart';
import 'settings_screen.dart';

class ProductionSettings extends StatefulWidget {
  const ProductionSettings({super.key});
  @override
  State<ProductionSettings> createState() => _ProductionSettingsState();
}

class _ProductionSettingsState extends State<ProductionSettings> {
  late final _prefs = PreferencesStore.open();
  bool _busy = false;
  void _message(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _toggle(bool enabled) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (!await AppSecurity.unlock()) {
        _message(L10n.current.settingsLockAuthRequired);
        return;
      }
      final prefs = await _prefs;
      if (!await prefs.setBool('pref.lock.enabled', value: enabled)) {
        throw StateError('Could not save');
      }
      AppSecurity.revision.value++;
    } catch (_) {
      _message(L10n.current.settingsLockSaveFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() async {
    try {
      final text = await const SettingsExporter().exportAsJson(await _prefs);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(c.l10n.settingsExportTitle),
          content: SingleChildScrollView(child: SelectableText(text)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: Text(c.l10n.commonClose),
            ),
            FilledButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));
                if (c.mounted) Navigator.pop(c);
              },
              child: Text(c.l10n.settingsCopyJson),
            ),
          ],
        ),
      );
    } catch (_) {
      _message(L10n.current.settingsExportFailed);
    }
  }

  Future<void> _import() async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _SettingsImportDialog(),
    );
    if (text == null) return;
    try {
      final count = await const SettingsImporter().importFromJson(
        text,
        await _prefs,
      );
      _message(L10n.current.settingsImported(count));
    } catch (_) {
      _message(L10n.current.settingsImportFailed);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.settingsTitle)),
    body: FutureBuilder<PreferencesStore>(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(context.l10n.settingsLoadFailed));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return AbsorbPointer(
          absorbing: _busy,
          child: SettingsScreen(
            about: AboutInfo.current(),
            lockEnabled: snapshot.data!.getBool('pref.lock.enabled') ?? false,
            onToggleLock: _toggle,
            onExport: _export,
            onImport: _import,
            lockUnavailableReason: PlatformCapabilities.deviceAuthentication
                ? null
                : context.l10n.settingsLockUnavailable(
                    PlatformCapabilities.inBuildName,
                  ),
          ),
        );
      },
    ),
  );
}

class _SettingsImportDialog extends StatefulWidget {
  const _SettingsImportDialog();
  @override
  State<_SettingsImportDialog> createState() => _SettingsImportDialogState();
}

class _SettingsImportDialogState extends State<_SettingsImportDialog> {
  final _text = TextEditingController();
  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.settingsImportTitle),
    content: TextField(
      controller: _text,
      maxLines: 8,
      maxLength: 65536,
      decoration: InputDecoration(hintText: context.l10n.settingsImportHint),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.commonCancel),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _text.text),
        child: Text(context.l10n.settingsImport),
      ),
    ],
  );
}
