import 'package:flutter/material.dart';

import 'appearance.dart';
import 'tokens.dart';

@immutable
class CourrierTheme {
  const CourrierTheme._();

  static ThemeData light([AccentChoice accent = AccentChoice.coderBlue]) =>
      build(Brightness.light, accent);

  static ThemeData dark([AccentChoice accent = AccentChoice.coderBlue]) =>
      build(Brightness.dark, accent);

  /// The theme for a mode and the user's accent. Containers (cards, dialogs, menus, bars) use the page
  /// background, so accent text on them keeps at least 4.5:1. Selection fills use
  /// [AccentChoice.selectionColor] (neutral for yellow and orange): no background is tinted yellow.
  static ThemeData build(Brightness brightness, AccentChoice accentChoice) {
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
    final textMuted = textSecondary;
    final accent = accentChoice.color(brightness);
    final onAccent = CoderPalette.color(CoderPalette.onAccent(brightness));
    final danger = CoderPalette.color(CoderPalette.danger(brightness));
    final selectionFill = accentChoice
        .selectionColor(brightness)
        .withValues(alpha: AccentChoice.selectionOpacity);
    final selectionOverlay = WidgetStateProperty.resolveWith<Color?>(
      (states) =>
          states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)
          ? selectionFill
          : null,
    );

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: onAccent,
      primaryContainer: selectionFill,
      onPrimaryContainer: textPrimary,
      secondary: accent,
      onSecondary: onAccent,
      secondaryContainer: selectionFill,
      onSecondaryContainer: textPrimary,
      tertiary: accent,
      onTertiary: onAccent,
      tertiaryContainer: selectionFill,
      onTertiaryContainer: textPrimary,
      error: danger,
      onError: onAccent,
      surface: background,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      surfaceContainerLowest: background,
      surfaceContainerLow: background,
      surfaceContainer: background,
      surfaceContainerHigh: background,
      surfaceContainerHighest: surface,
      outline: border,
      outlineVariant: border,
      inverseSurface: textPrimary,
      onInverseSurface: background,
      inversePrimary: accentChoice.color(
        isDark ? Brightness.light : Brightness.dark,
      ),
      // No accent tint on elevated surfaces (dialogs, menus, sheets).
      surfaceTint: Colors.transparent,
      shadow: Colors.black,
      scrim: Colors.black,
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
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 64,
        indicatorColor: selectionFill,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelLarge?.copyWith(
            color: states.contains(WidgetState.selected)
                ? accent
                : textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? accent
                : textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: background,
        indicatorColor: selectionFill,
        selectedIconTheme: IconThemeData(color: accent),
        unselectedIconTheme: IconThemeData(color: textSecondary),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(color: accent),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: textSecondary,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accent,
        selectionColor: accentChoice
            .selectionColor(brightness)
            .withValues(alpha: AccentChoice.textSelectionOpacity),
        selectionHandleColor: accent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: background,
        surfaceTintColor: Colors.transparent,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      listTileTheme: ListTileThemeData(
        selectedColor: accent,
        selectedTileColor: selectionFill,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? selectionFill
                : Colors.transparent,
          ),
          // Labels on a selection fill stay in the text colour (at least 4.5:1 on every fill).
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? textSecondary
                : textPrimary,
          ),
          overlayColor: selectionOverlay,
          side: WidgetStatePropertyAll(BorderSide(color: border)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) =>
                states.contains(WidgetState.disabled) ? textSecondary : accent,
          ),
          overlayColor: selectionOverlay,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onAccent,
        ),
      ),
      chipTheme: ChipThemeData(
        selectedColor: selectionFill,
        backgroundColor: background,
        side: BorderSide(color: border),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: background),
        actionTextColor: background,
      ),
      cardTheme: CardThemeData(
        color: background,
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
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accent),
          borderRadius: const BorderRadius.all(
            Radius.circular(CourrierTokens.borderRadius),
          ),
        ),
      ),
      visualDensity: VisualDensity.compact,
      splashFactory: NoSplash.splashFactory,
    );
  }
}
