import 'package:flutter/material.dart';

import '../../../core/settings/appearance_controller.dart';
import '../../../core/theme/appearance.dart';
import '../../../core/theme/tokens.dart';
import '../../../l10n/l10n.dart';

/// Settings → Appearance: the app language (menu), the mode (segmented) and the accent (swatches), the same
/// as in the other Établi apps. Everything applies at once.
class AppearanceSection extends StatelessWidget {
  const AppearanceSection({required this.controller, super.key});

  final AppearanceController controller;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final theme = Theme.of(context);
      final l10n = context.l10n;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.settingsLanguage,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(width: CourrierTokens.space2),
              DropdownButton<AppLanguage>(
                key: const ValueKey('settings.appearance.language'),
                value: controller.language,
                underline: const SizedBox.shrink(),
                dropdownColor: theme.colorScheme.surface,
                style: theme.textTheme.bodyLarge,
                onChanged: (value) {
                  if (value != null) controller.setLanguage(value);
                },
                items: [
                  for (final option in AppLanguage.values)
                    DropdownMenuItem(
                      value: option,
                      child: Text(
                        l10n.languageLabel(option),
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: CourrierTokens.space3),
          Text(l10n.settingsMode, style: theme.textTheme.bodyLarge),
          const SizedBox(height: CourrierTokens.space2),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<AppearanceMode>(
              key: const ValueKey('settings.appearance.mode'),
              showSelectedIcon: false,
              segments: [
                for (final option in AppearanceMode.values)
                  ButtonSegment(
                    value: option,
                    label: Text(
                      l10n.modeLabel(option),
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
              ],
              selected: {controller.mode},
              onSelectionChanged: (selection) =>
                  controller.setMode(selection.first),
            ),
          ),
          const SizedBox(height: CourrierTokens.space3),
          ExcludeSemantics(
            child: Text(l10n.settingsAccent, style: theme.textTheme.bodyLarge),
          ),
          const SizedBox(height: CourrierTokens.space2),
          Wrap(
            children: [
              for (final option in AccentChoice.values)
                _Swatch(
                  choice: option,
                  selected: option == controller.accent,
                  label: l10n.accentLabel(option),
                  hint: l10n.settingsAccent,
                  onTap: () => controller.setAccent(option),
                ),
            ],
          ),
          const SizedBox(height: CourrierTokens.space2),
          Text(l10n.settingsAppearanceNote, style: theme.textTheme.bodySmall),
        ],
      );
    },
  );
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.choice,
    required this.selected,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  final AccentChoice choice;
  final bool selected;
  final String label;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    return Semantics(
      key: ValueKey('settings.appearance.accent.${choice.name}'),
      label: label,
      hint: hint,
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      excludeSemantics: true,
      onTap: onTap,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: choice.color(brightness),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.outline,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: CoderPalette.color(
                          CoderPalette.onAccent(brightness),
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
