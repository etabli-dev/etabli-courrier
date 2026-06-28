import 'package:flutter/material.dart';

import '../../../core/config/preferences_store.dart';
import '../../../core/theme/tokens.dart';

// One-shot post-update dialog. The shell checks `WhatsNewService.shouldShow`
// on cold start; if true it shows this dialog and the service flips the
// recorded "last seen" version so it doesn't fire again until the next
// upgrade.

class WhatsNewService {
  WhatsNewService({
    required this.preferences,
    required this.currentVersion,
    required this.notes,
  });

  final PreferencesStore preferences;
  final String currentVersion;

  /// Bullet-list lines surfaced in the dialog. M14 bundles the canonical
  /// CHANGELOG and the shell passes the relevant section in.
  final List<String> notes;

  static const _lastSeenKey = 'pref.whats_new.last_seen_version';

  Future<bool> shouldShow() async {
    final lastSeen = preferences.getString(_lastSeenKey);
    return lastSeen != currentVersion;
  }

  Future<void> markSeen() async {
    await preferences.setString(_lastSeenKey, currentVersion);
  }
}

class WhatsNewDialog extends StatelessWidget {
  const WhatsNewDialog({
    required this.versionLabel,
    required this.notes,
    super.key,
  });

  final String versionLabel;
  final List<String> notes;

  static Future<void> showIfNeeded({
    required BuildContext context,
    required WhatsNewService service,
  }) async {
    if (!await service.shouldShow()) {
      return;
    }
    if (!context.mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (_) => WhatsNewDialog(
        versionLabel: service.currentVersion,
        notes: service.notes,
      ),
    );
    await service.markSeen();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: Text(
        "What's new in $versionLabel",
        style: theme.textTheme.titleMedium,
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final note in notes)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: CourrierTokens.space1,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 6,
                        right: CourrierTokens.space2,
                      ),
                      child: Icon(
                        Icons.fiber_manual_record,
                        size: 6,
                        color: CourrierTokens.accent,
                      ),
                    ),
                    Expanded(
                      child: Text(note, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
