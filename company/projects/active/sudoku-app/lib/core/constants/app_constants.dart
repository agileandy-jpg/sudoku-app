/// Core constants for the Sudoku application.
library;

/// Application-wide constants.
abstract class AppConstants {
  /// Private constructor to prevent instantiation.
  const AppConstants._();

  /// Grid size for a standard Sudoku puzzle.
  static const int gridSize = 9;

  /// Sub-grid size (3x3 boxes).
  static const int subGridSize = 3;

  /// Minimum valid cell value.
  static const int minCellValue = 1;

  /// Maximum valid cell value.
  static const int maxCellValue = 9;

  /// Empty cell value.
  static const int emptyCellValue = 0;

  /// App name.
  static const String appName = 'Sudoku';

  /// App version.
  static const String appVersion = '1.0.0';
}

/// Storage keys for SharedPreferences.
abstract class StorageKeys {
  /// Private constructor to prevent instantiation.
  const StorageKeys._();

  /// Key for storing game settings.
  static const String settings = 'sudoku_settings';

  /// Key for storing current game state.
  static const String currentGame = 'sudoku_current_game';

  /// Key for storing game statistics.
  static const String statistics = 'sudoku_statistics';

  /// Key for storing last difficulty.
  static const String lastDifficulty = 'sudoku_last_difficulty';
}

/// Animation durations.
abstract class Durations {
  /// Private constructor to prevent instantiation.
  const Durations._();

  /// Short animation duration (100ms).
  static const Duration short = Duration(milliseconds: 100);

  /// Medium animation duration (200ms).
  static const Duration medium = Duration(milliseconds: 200);

  /// Long animation duration (300ms).
  static const Duration long = Duration(milliseconds: 300);
}
