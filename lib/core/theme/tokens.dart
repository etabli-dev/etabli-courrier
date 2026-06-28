// THE ONLY FILE IN THE TREE THAT MAY CONTAIN HEX COLOR LITERALS.
// Enforced by AUDIT_LOOP.md dimension 8 (grep gate). See CLAUDE.md aesthetic section.

import 'package:flutter/material.dart';

@immutable
class CourrierTokens {
  const CourrierTokens._();

  // The single accent. Sourced from CLAUDE.md aesthetic. Do not introduce a second accent.
  static const Color accent = Color(0xFF28A745);

  // Light palette — minimal, whitespace-heavy, borders over shadows.
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightSurface = Color(0xFFFAFAFA);
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF555555);
  static const Color lightTextMuted = Color(0xFF888888);

  // Dark palette.
  static const Color darkBackground = Color(0xFF0E0E0E);
  static const Color darkSurface = Color(0xFF151515);
  static const Color darkBorder = Color(0xFF262626);
  static const Color darkTextPrimary = Color(0xFFF2F2F2);
  static const Color darkTextSecondary = Color(0xFFB5B5B5);
  static const Color darkTextMuted = Color(0xFF808080);

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

  // Type — monospaced per Coder/Hugo aesthetic. Fonts ship system-supplied at M0;
  // a bundled mono face can be added at M11 if needed.
  static const String monoFontFamily = 'Menlo';
}
