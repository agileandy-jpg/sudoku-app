/// Color constants specifically for the Sudoku grid.
library;

import 'package:flutter/material.dart';

/// {@template grid_colors}
/// Color constants used specifically for rendering the Sudoku grid.
/// 
/// These colors are separate from the main app theme to allow
/// for more granular control over the game board appearance.
/// 
/// Each theme (light/dark) has its own set of grid colors.
/// {@endtemplate}
class GridColors {
  /// Private constructor to prevent instantiation.
  const GridColors._();

  // ==================== Light Theme ====================

  /// Thin grid line color (1dp) for light theme.
  /// 
  /// Hex: #E0E0E0
  static const Color lightGridLineThin = Color(0xFFE0E0E0);

  /// Thick grid line color (2dp, 3x3 borders) for light theme.
  /// 
  /// Hex: #9E9E9E
  static const Color lightGridLineThick = Color(0xFF9E9E9E);

  /// Selected cell background color for light theme.
  /// 
  /// Hex: #E3F2FD (light blue tint)
  static const Color lightCellSelected = Color(0xFFE3F2FD);

  /// Highlighted cell background for row/column/box of selected cell.
  /// 
  /// Hex: #F5F9FF (very light blue)
  static const Color lightCellHighlighted = Color(0xFFF5F9FF);

  /// Background for cells with the same number as selected.
  /// 
  /// Hex: #E8F5E9 (light green tint)
  static const Color lightCellMatch = Color(0xFFE8F5E9);

  /// Color for given/fixed numbers in the puzzle.
  /// 
  /// Hex: #000000 (black)
  static const Color lightGivenNumber = Color(0xFF000000);

  /// Color for user-entered numbers.
  /// 
  /// Hex: #1565C0 (dark blue)
  static const Color lightUserNumber = Color(0xFF1565C0);

  /// Color for note/pencil mark text.
  /// 
  /// Hex: #757575 (medium gray)
  static const Color lightNoteText = Color(0xFF757575);

  /// Error state color for invalid numbers.
  /// 
  /// Hex: #E57373 (soft red)
  static const Color lightError = Color(0xFFE57373);

  /// Error background color for cells with conflicts.
  /// 
  /// Hex: #FFEBEE (very light red)
  static const Color lightErrorBackground = Color(0xFFFFEBEE);

  // ==================== Dark Theme ====================

  /// Thin grid line color (1dp) for dark theme.
  /// 
  /// Hex: #424242
  static const Color darkGridLineThin = Color(0xFF424242);

  /// Thick grid line color (2dp, 3x3 borders) for dark theme.
  /// 
  /// Hex: #616161
  static const Color darkGridLineThick = Color(0xFF616161);

  /// Selected cell background color for dark theme.
  /// 
  /// Hex: #1A3A5C (dark blue tint)
  static const Color darkCellSelected = Color(0xFF1A3A5C);

  /// Highlighted cell background for row/column/box of selected cell.
  /// 
  /// Hex: #1E2A3A (dark blue-gray)
  static const Color darkCellHighlighted = Color(0xFF1E2A3A);

  /// Background for cells with the same number as selected.
  /// 
  /// Hex: #1B3B2B (dark green tint)
  static const Color darkCellMatch = Color(0xFF1B3B2B);

  /// Color for given/fixed numbers in the puzzle.
  /// 
  /// Hex: #FFFFFF (white)
  static const Color darkGivenNumber = Color(0xFFFFFFFF);

  /// Color for user-entered numbers.
  /// 
  /// Hex: #90CAF9 (light blue)
  static const Color darkUserNumber = Color(0xFF90CAF9);

  /// Color for note/pencil mark text.
  /// 
  /// Hex: #B0B0B0 (light gray)
  static const Color darkNoteText = Color(0xFFB0B0B0);

  /// Error state color for invalid numbers.
  /// 
  /// Hex: #EF5350 (light red)
  static const Color darkError = Color(0xFFEF5350);

  /// Error background color for cells with conflicts.
  /// 
  /// Hex: #3E2723 (dark red-brown)
  static const Color darkErrorBackground = Color(0xFF3E2723);

  // ==================== Helper Methods ====================

  /// Returns the appropriate color based on theme brightness.
  /// 
  /// [isDark] determines whether to use dark or light theme colors.
  static Color gridLineThin({required bool isDark}) =>
      isDark ? darkGridLineThin : lightGridLineThin;

  /// Returns the appropriate thick grid line color.
  static Color gridLineThick({required bool isDark}) =>
      isDark ? darkGridLineThick : lightGridLineThick;

  /// Returns the appropriate selected cell background color.
  static Color cellSelected({required bool isDark}) =>
      isDark ? darkCellSelected : lightCellSelected;

  /// Returns the appropriate highlighted cell background color.
  static Color cellHighlighted({required bool isDark}) =>
      isDark ? darkCellHighlighted : lightCellHighlighted;

  /// Returns the appropriate matching cell background color.
  static Color cellMatch({required bool isDark}) =>
      isDark ? darkCellMatch : lightCellMatch;

  /// Returns the appropriate given number text color.
  static Color givenNumber({required bool isDark}) =>
      isDark ? darkGivenNumber : lightGivenNumber;

  /// Returns the appropriate user number text color.
  static Color userNumber({required bool isDark}) =>
      isDark ? darkUserNumber : lightUserNumber;

  /// Returns the appropriate note text color.
  static Color noteText({required bool isDark}) =>
      isDark ? darkNoteText : lightNoteText;

  /// Returns the appropriate error color.
  static Color error({required bool isDark}) =>
      isDark ? darkError : lightError;

  /// Returns the appropriate error background color.
  static Color errorBackground({required bool isDark}) =>
      isDark ? darkErrorBackground : lightErrorBackground;
}
