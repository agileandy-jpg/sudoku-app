/// Utility functions for the Sudoku application.
library;

import 'dart:math';

/// {@template grid_utils}
/// Utility functions for Sudoku grid operations.
/// {@endtemplate}
abstract class GridUtils {
  /// Private constructor to prevent instantiation.
  const GridUtils._();

  /// Calculates the sub-grid (box) index for a given cell position.
  /// 
  /// The Sudoku grid is divided into 9 sub-grids (3x3 boxes).
  /// This method returns which box a cell belongs to (0-8).
  /// 
  /// [row] The row index (0-8).
  /// [col] The column index (0-8).
  /// 
  /// Returns the box index (0-8).
  /// 
  /// Example:
  /// ```dart
  /// GridUtils.getBoxIndex(0, 0); // 0 (top-left box)
  /// GridUtils.getBoxIndex(4, 4); // 4 (center box)
  /// GridUtils.getBoxIndex(8, 8); // 8 (bottom-right box)
  /// ```
  static int getBoxIndex(int row, int col) {
    final int boxRow = row ~/ 3;
    final int boxCol = col ~/ 3;
    return boxRow * 3 + boxCol;
  }

  /// Gets the starting row index for a given box.
  /// 
  /// [boxIndex] The box index (0-8).
  /// 
  /// Returns the starting row of the box (0, 3, or 6).
  static int getBoxStartRow(int boxIndex) {
    return (boxIndex ~/ 3) * 3;
  }

  /// Gets the starting column index for a given box.
  /// 
  /// [boxIndex] The box index (0-8).
  /// 
  /// Returns the starting column of the box (0, 3, or 6).
  static int getBoxStartCol(int boxIndex) {
    return (boxIndex % 3) * 3;
  }

  /// Gets all cell positions in a given row.
  /// 
  /// [row] The row index (0-8).
  /// 
  /// Returns a list of (row, col) tuples for all cells in the row.
  static List<(int, int)> getRowPositions(int row) {
    return List.generate(9, (col) => (row, col));
  }

  /// Gets all cell positions in a given column.
  /// 
  /// [col] The column index (0-8).
  /// 
  /// Returns a list of (row, col) tuples for all cells in the column.
  static List<(int, int)> getColPositions(int col) {
    return List.generate(9, (row) => (row, col));
  }

  /// Gets all cell positions in a given box.
  /// 
  /// [boxIndex] The box index (0-8).
  /// 
  /// Returns a list of (row, col) tuples for all cells in the box.
  static List<(int, int)> getBoxPositions(int boxIndex) {
    final List<(int, int)> positions = [];
    final int startRow = getBoxStartRow(boxIndex);
    final int startCol = getBoxStartCol(boxIndex);

    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 3; c++) {
        positions.add((startRow + r, startCol + c));
      }
    }

    return positions;
  }

  /// Checks if two cells are in the same row, column, or box.
  /// 
  /// [row1], [col1] Position of the first cell.
  /// [row2], [col2] Position of the second cell.
  /// 
  /// Returns true if the cells are related (same row, col, or box).
  static bool areRelated(int row1, int col1, int row2, int col2) {
    if (row1 == row2 || col1 == col2) {
      return true;
    }
    return getBoxIndex(row1, col1) == getBoxIndex(row2, col2);
  }

  /// Gets all positions related to a given cell (same row, column, or box).
  /// 
  /// [row] The row index (0-8).
  /// [col] The column index (0-8).
  /// 
  /// Returns a set of (row, col) tuples for all related cells.
  static Set<(int, int)> getRelatedPositions(int row, int col) {
    final Set<(int, int)> positions = {};

    // Add all cells in the same row
    for (int c = 0; c < 9; c++) {
      if (c != col) {
        positions.add((row, c));
      }
    }

    // Add all cells in the same column
    for (int r = 0; r < 9; r++) {
      if (r != row) {
        positions.add((r, col));
      }
    }

    // Add all cells in the same box
    final int boxIndex = getBoxIndex(row, col);
    final int startRow = getBoxStartRow(boxIndex);
    final int startCol = getBoxStartCol(boxIndex);

    for (int r = startRow; r < startRow + 3; r++) {
      for (int c = startCol; c < startCol + 3; c++) {
        if (r != row || c != col) {
          positions.add((r, c));
        }
      }
    }

    return positions;
  }
}

/// {@template math_utils}
/// Mathematical utility functions.
/// {@endtemplate}
abstract class MathUtils {
  /// Private constructor to prevent instantiation.
  const MathUtils._();

  /// Random number generator.
  static final Random _random = Random();

  /// Generates a random integer in the range [min, max] (inclusive).
  /// 
  /// [min] The minimum value (inclusive).
  /// [max] The maximum value (inclusive).
  /// 
  /// Returns a random integer between min and max.
  /// 
  /// Throws [ArgumentError] if min > max.
  static int randomInt(int min, int max) {
    if (min > max) {
      throw ArgumentError('min must be <= max');
    }
    return min + _random.nextInt(max - min + 1);
  }

  /// Shuffles a list in-place using the Fisher-Yates algorithm.
  /// 
  /// [list] The list to shuffle.
  static void shuffle<T>(List<T> list) {
    for (int i = list.length - 1; i > 0; i--) {
      final int j = _random.nextInt(i + 1);
      final T temp = list[i];
      list[i] = list[j];
      list[j] = temp;
    }
  }

  /// Returns a shuffled copy of a list.
  /// 
  /// [list] The list to shuffle.
  /// 
  /// Returns a new list with the same elements in random order.
  static List<T> shuffled<T>(List<T> list) {
    final List<T> result = List<T>.from(list);
    shuffle(result);
    return result;
  }
}
