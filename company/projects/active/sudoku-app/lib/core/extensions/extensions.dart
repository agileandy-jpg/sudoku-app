/// Extensions for common Flutter and Dart types.
library;

import 'package:flutter/material.dart';

/// {@template duration_extensions}
/// Extension methods for [Duration] formatting.
/// {@endtemplate}
extension DurationExtensions on Duration {
  /// Formats the duration as MM:SS for display in the game timer.
  /// 
  /// Example:
  /// ```dart
  /// const duration = Duration(minutes: 12, seconds: 34);
  /// print(duration.formatted); // "12:34"
  /// ```
  String get formatted {
    final String minutes = inMinutes.toString().padLeft(2, '0');
    final String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Formats the duration as HH:MM:SS for longer durations.
  /// 
  /// Example:
  /// ```dart
  /// const duration = Duration(hours: 1, minutes: 5, seconds: 9);
  /// print(duration.formattedLong); // "01:05:09"
  /// ```
  String get formattedLong {
    final String hours = inHours.toString().padLeft(2, '0');
    final String minutes = (inMinutes % 60).toString().padLeft(2, '0');
    final String seconds = (inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

/// {@template build_context_extensions}
/// Extension methods for [BuildContext] to simplify common operations.
/// {@endtemplate}
extension BuildContextExtensions on BuildContext {
  /// Returns the current [ThemeData] from the closest [Theme] ancestor.
  ThemeData get theme => Theme.of(this);

  /// Returns the current [ColorScheme] from the theme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the current [TextTheme] from the theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the current [MediaQueryData] from the closest [MediaQuery] ancestor.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the size of the current media (e.g., the screen size).
  Size get screenSize => MediaQuery.of(this).size;

  /// Returns true if the current theme brightness is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns the device pixel ratio.
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Returns true if the keyboard is currently visible.
  bool get isKeyboardVisible =>
      MediaQuery.of(this).viewInsets.bottom > 0;
}

/// {@template int_extensions}
/// Extension methods for [int].
/// {@endtemplate}
extension IntExtensions on int {
  /// Returns this integer clamped to valid Sudoku cell values (1-9).
  /// 
  /// Values outside 1-9 range return null.
  /// 
  /// Example:
  /// ```dart
  /// 5.toValidCellValue;    // 5
  /// 10.toValidCellValue;   // null
  /// 0.toValidCellValue;    // null
  /// ```
  int? get toValidCellValue {
    if (this >= 1 && this <= 9) {
      return this;
    }
    return null;
  }

  /// Formats the integer with leading zeros to ensure minimum width.
  /// 
  /// Example:
  /// ```dart
  /// 5.padLeft(2);  // "05"
  /// 42.padLeft(3); // "042"
  /// ```
  String padLeft(int width) => toString().padLeft(width, '0');
}

/// {@template string_extensions}
/// Extension methods for [String].
/// {@endtemplate}
extension StringExtensions on String {
  /// Truncates the string to the specified [maxLength] and adds ellipsis if truncated.
  /// 
  /// Example:
  /// ```dart
  /// 'Hello World'.truncate(8); // "Hello..."
  /// 'Hi'.truncate(8);          // "Hi"
  /// ```
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) {
      return this;
    }
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Capitalizes the first letter of the string.
  /// 
  /// Example:
  /// ```dart
  /// 'hello'.capitalizeFirst; // "Hello"
  /// ''.capitalizeFirst;      // ""
  /// ```
  String get capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
