import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/config/preferences_store.dart';
import '../../../core/lock/app_security.dart';
import '../../../core/platform/platform_capabilities.dart';
import '../../../core/settings/about_info.dart';
import '../../../core/settings/settings_io.dart';
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
        _message('Device authentication is required to change app lock.');
        return;
      }
      final prefs = await _prefs;
      if (!await prefs.setBool('pref.lock.enabled', value: enabled)) {
        throw StateError('Could not save');
      }
      AppSecurity.revision.value++;
    } catch (_) {
      _message('Could not save app-lock settings.');
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
          title: const Text('Non-sensitive settings'),
          content: SingleChildScrollView(child: SelectableText(text)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: text));
                if (c.mounted) Navigator.pop(c);
              },
              child: const Text('Copy JSON'),
            ),
          ],
        ),
      );
    } catch (_) {
      _message('Could not export settings.');
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
      _message('Imported $count preferences.');
    } catch (_) {
      _message(
        'Import failed. Use a supported settings export with valid preference values.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: FutureBuilder<PreferencesStore>(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Could not load settings. Reopen this screen to retry.',
            ),
          );
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
                : 'Not available in ${PlatformCapabilities.buildName}: it has no '
                      'device-authentication service.',
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
    title: const Text('Import settings JSON'),
    content: TextField(
      controller: _text,
      maxLines: 8,
      maxLength: 65536,
      decoration: const InputDecoration(
        hintText:
            'Paste a settings export. App lock and credentials are excluded.',
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, _text.text),
        child: const Text('Import'),
      ),
    ],
  );
}
