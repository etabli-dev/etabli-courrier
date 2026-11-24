import 'package:flutter/material.dart';

import '../../../core/sync/conflict_resolver.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/l10n.dart';

// Dialog used by the AppShell-level ConflictResolver to surface a single
// conflict's payloads + ask the user to choose. Pure widget; no IO.

class ConflictResolutionDialog extends StatelessWidget {
  const ConflictResolutionDialog({required this.context, super.key});

  final ConflictContext context;

  static Future<ConflictResolution?> show({
    required BuildContext parent,
    required ConflictContext context,
  }) {
    return showDialog<ConflictResolution>(
      context: parent,
      builder: (_) => ConflictResolutionDialog(context: context),
    );
  }

  @override
  Widget build(BuildContext build) {
    final theme = Theme.of(build);
    final l10n = build.l10n;
    return AlertDialog(
      title: Text(
        l10n.syncConflictTitle(context.entityTable),
        style: theme.textTheme.titleMedium,
      ),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.syncConflictBody, style: theme.textTheme.bodyMedium),
            const SizedBox(height: CourrierTokens.space3),
            _PayloadColumn(
              label: l10n.syncConflictLocal,
              payload: context.localPayload,
            ),
            const SizedBox(height: CourrierTokens.space3),
            _PayloadColumn(
              label: l10n.syncConflictServer,
              payload: context.serverPayload,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () =>
              Navigator.of(build).pop(ConflictResolution.keepServer),
          child: Text(l10n.syncConflictKeepServer),
        ),
        TextButton(
          onPressed: () => Navigator.of(build).pop(ConflictResolution.keepBoth),
          child: Text(l10n.syncConflictKeepBoth),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(build).pop(ConflictResolution.keepLocal),
          child: Text(l10n.syncConflictKeepLocal),
        ),
      ],
    );
  }
}

class _PayloadColumn extends StatelessWidget {
  const _PayloadColumn({required this.label, required this.payload});

  final String label;
  final String payload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: CourrierTokens.space1),
        Container(
          padding: const EdgeInsets.all(CourrierTokens.space2),
          decoration: BoxDecoration(
            border: Border.all(color: theme.dividerTheme.color!),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              payload.length > 800 ? '${payload.substring(0, 800)}…' : payload,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}

/// Dialog-backed ConflictResolver — what the shell wires by default once it
/// has a BuildContext. Pure-widget; no IO.
class DialogConflictResolver implements ConflictResolver {
  DialogConflictResolver({required this.contextProvider});

  /// Closure that returns the current BuildContext. Provided by a top-level
  /// `GlobalKey&lt;NavigatorState&gt;` in the shell so the resolver can run
  /// from background-sync callbacks.
  final BuildContext? Function() contextProvider;

  @override
  Future<ConflictResolution> resolve(ConflictContext context) async {
    final parent = contextProvider();
    if (parent == null) {
      return ConflictResolution.defer;
    }
    final choice = await ConflictResolutionDialog.show(
      parent: parent,
      context: context,
    );
    return choice ?? ConflictResolution.defer;
  }
}
