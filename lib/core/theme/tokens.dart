// THE ONLY FILES IN THE TREE THAT MAY CONTAIN HEX COLOR LITERALS: this one and appearance.dart.
// Do not add hex color literals anywhere else; use these tokens or the theme.

import 'package:flutter/material.dart';

import 'appearance.dart';

@immutable
class CourrierTokens {
  const CourrierTokens._();

  // Hugo Coder neutrals (appearance.dart, shared with every Établi app). The accent is the user's choice:
  // widgets read `Theme.of(context).colorScheme.primary`, never a fixed colour.
  static final Color lightBackground = CoderPalette.color(
    CoderPalette.backgroundLight,
  );
  static final Color lightSurface = CoderPalette.color(
    CoderPalette.surfaceLight,
  );
  static final Color lightBorder = CoderPalette.color(CoderPalette.borderLight);
  static final Color lightTextPrimary = CoderPalette.color(
    CoderPalette.foregroundLight,
  );
  static final Color lightTextSecondary = CoderPalette.color(
    CoderPalette.mutedLight,
  );

  static final Color darkBackground = CoderPalette.color(
    CoderPalette.backgroundDark,
  );
  static final Color darkSurface = CoderPalette.color(CoderPalette.surfaceDark);
  static final Color darkBorder = CoderPalette.color(CoderPalette.borderDark);
  static final Color darkTextPrimary = CoderPalette.color(
    CoderPalette.foregroundDark,
  );
  static final Color darkTextSecondary = CoderPalette.color(
    CoderPalette.mutedDark,
  );

  // Spacing scale (4pt grid).
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;
  static const double space7 = 48;

  // Borders (we use borders, not shadows).
  static const double borderWidth = 1;
  static const double borderRadius = 2;

  // Type — monospaced per Coder/Hugo aesthetic, system-supplied.
  static const String monoFontFamily = 'Menlo';
}
