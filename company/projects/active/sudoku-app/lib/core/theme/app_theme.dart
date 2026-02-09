/// App theme configuration for light and dark modes.
library;

import 'package:flutter/material.dart';

/// {@template app_theme}
/// Provides light and dark theme configurations for the Sudoku app.
/// 
/// All colors are based on the UI specifications document with
/// specific hex values for consistent branding.
/// {@endtemplate}
class AppTheme {
  /// Private constructor to prevent instantiation.
  const AppTheme._();

  /// Returns the light theme configuration.
  /// 
  /// Based on Material Design 3 with custom color scheme:
  /// - Background: Off-white (#FAFAFA)
  /// - Surface: Pure white (#FFFFFF)
  /// - Primary: Calm blue (#4A90D9)
  /// - Error: Soft red (#E57373)
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: Color(0xFFFAFAFA),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF333333),
        onSurfaceVariant: Color(0xFF757575),
        primary: Color(0xFF4A90D9),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFE3F2FD),
        secondary: Color(0xFF5AC8A8),
        onSecondary: Color(0xFF000000),
        error: Color(0xFFE57373),
        onError: Color(0xFFFFFFFF),
        outline: Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFF333333),
        ),
        titleTextStyle: TextStyle(
          color: Color(0xFF333333),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFF4A90D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF4A90D9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: Color(0xFF4A90D9),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4A90D9),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF4A90D9);
          }
          return const Color(0xFF9E9E9E);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF4A90D9).withAlpha(128);
          }
          return const Color(0xFFE0E0E0);
        }),
      ),
    );
  }

  /// Returns the dark theme configuration.
  /// 
  /// Based on Material Design 3 dark theme with custom color scheme:
  /// - Background: Dark charcoal (#121212)
  /// - Surface: Lighter charcoal (#1E1E1E)
  /// - Primary: Light blue (#6AB7FF)
  /// - Error: Light red (#EF5350)
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFE0E0E0),
        onSurfaceVariant: Color(0xFFB0B0B0),
        primary: Color(0xFF6AB7FF),
        onPrimary: Color(0xFF121212),
        primaryContainer: Color(0xFF1A3A5C),
        secondary: Color(0xFF5AC8A8),
        onSecondary: Color(0xFF000000),
        error: Color(0xFFEF5350),
        onError: Color(0xFF000000),
        outline: Color(0xFF424242),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Color(0xFFE0E0E0),
        ),
        titleTextStyle: TextStyle(
          color: Color(0xFFE0E0E0),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF121212),
          backgroundColor: const Color(0xFF6AB7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6AB7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(
            color: Color(0xFF6AB7FF),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF6AB7FF),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF6AB7FF);
          }
          return const Color(0xFF616161);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF6AB7FF).withAlpha(128);
          }
          return const Color(0xFF424242);
        }),
      ),
    );
  }
}
