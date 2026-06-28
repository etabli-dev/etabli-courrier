import 'package:flutter/material.dart';

import 'tokens.dart';

@immutable
class CourrierTheme {
  const CourrierTheme._();

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final background = isDark
        ? CourrierTokens.darkBackground
        : CourrierTokens.lightBackground;
    final surface = isDark
        ? CourrierTokens.darkSurface
        : CourrierTokens.lightSurface;
    final border = isDark
        ? CourrierTokens.darkBorder
        : CourrierTokens.lightBorder;
    final textPrimary = isDark
        ? CourrierTokens.darkTextPrimary
        : CourrierTokens.lightTextPrimary;
    final textSecondary = isDark
        ? CourrierTokens.darkTextSecondary
        : CourrierTokens.lightTextSecondary;
    final textMuted = isDark
        ? CourrierTokens.darkTextMuted
        : CourrierTokens.lightTextMuted;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: CourrierTokens.accent,
      onPrimary: isDark
          ? CourrierTokens.darkBackground
          : CourrierTokens.lightBackground,
      secondary: CourrierTokens.accent,
      onSecondary: isDark
          ? CourrierTokens.darkBackground
          : CourrierTokens.lightBackground,
      error: CourrierTokens.accent,
      onError: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      outline: border,
    );

    final textTheme = TextTheme(
      bodyLarge: TextStyle(
        color: textPrimary,
        fontFamily: CourrierTokens.monoFontFamily,
        fontSize: 14,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontFamily: CourrierTokens.monoFontFamily,
        fontSize: 13,
      ),
      bodySmall: TextStyle(
        color: textMuted,
        fontFamily: CourrierTokens.monoFontFamily,
        fontSize: 12,
      ),
      titleLarge: TextStyle(
        color: textPrimary,
        fontFamily: CourrierTokens.monoFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: textPrimary,
        fontFamily: CourrierTokens.monoFontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      labelLarge: TextStyle(
        color: textPrimary,
        fontFamily: CourrierTokens.monoFontFamily,
        fontSize: 13,
      ),
    );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      canvasColor: background,
      textTheme: textTheme,
      fontFamily: CourrierTokens.monoFontFamily,
      dividerTheme: DividerThemeData(
        color: border,
        thickness: CourrierTokens.borderWidth,
        space: CourrierTokens.borderWidth,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: Border(bottom: BorderSide(color: border)),
        titleTextStyle: textTheme.titleMedium,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: background,
        elevation: 0,
        height: 64,
        indicatorColor: surface,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        iconTheme: WidgetStatePropertyAll(IconThemeData(color: textPrimary)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: background,
        selectedIconTheme: const IconThemeData(color: CourrierTokens.accent),
        unselectedIconTheme: IconThemeData(color: textSecondary),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: CourrierTokens.accent,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: textSecondary,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border),
          borderRadius: const BorderRadius.all(
            Radius.circular(CourrierTokens.borderRadius),
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: border),
          borderRadius: const BorderRadius.all(
            Radius.circular(CourrierTokens.borderRadius),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CourrierTokens.accent),
          borderRadius: BorderRadius.all(
            Radius.circular(CourrierTokens.borderRadius),
          ),
        ),
      ),
      visualDensity: VisualDensity.compact,
      splashFactory: NoSplash.splashFactory,
    );
  }
}
