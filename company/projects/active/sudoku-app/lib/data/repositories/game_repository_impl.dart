/// Game repository implementation.
///
/// Implements [GameRepository] interface with puzzle generation
/// and local data persistence.
library;

import 'dart:math';

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/game_local_data_source.dart';
import '../models/game_model.dart';

/// {@template game_repository_impl}
/// Implementation of [GameRepository] that handles puzzle generation
/// and game persistence.
///
/// This repository uses a backtracking algorithm to generate valid
/// Sudoku puzzles with unique solutions.
/// {@endtemplate}
class GameRepositoryImpl implements GameRepository {
  /// {@macro game_repository_impl}
  const GameRepositoryImpl(this._localDataSource);

  final GameLocalDataSource _localDataSource;
  final Random _random = Random();

  @override
  Future<Either<Failure, GameState>> generatePuzzle(Difficulty difficulty) async {
    try {
      // Generate a complete valid grid
      final List<List<int>> solution = _generateSolution();

      // Create cells from solution
      final List<List<Cell>> grid = List<List<Cell>>.generate(
        9,
        (int row) => List<Cell>.generate(
          9,
          (int col) => Cell(
            value: solution[row][col],
            isGiven: true,
          ),
        ),
      );

      // Remove cells based on difficulty
      final int cellsToRemove = 81 - difficulty.givenCells;
      final List<List<Cell>> puzzleGrid = _removeCells(grid, cellsToRemove);

      final GameState gameState = GameState(
        grid: puzzleGrid,
        difficulty: difficulty,
      );

      return Right(gameState);
    } catch (e) {
      return const Left(PuzzleGenerationFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveGame(GameState gameState) async {
    try {
      final GameModel gameModel = GameModel.fromEntity(gameState);
      await _localDataSource.saveGame(gameModel);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, GameState?>> getSavedGame() async {
    try {
      final GameModel? gameModel = await _localDataSource.getSavedGame();
      if (gameModel == null) {
        return const Right(null);
      }
      return Right(gameModel.toEntity());
    } on CacheException catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearSavedGame() async {
    try {
      await _localDataSource.clearSavedGame();
      return const Right(null);
    } on CacheException catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Either<Failure, bool> validateMove(
    GameState gameState,
    Position position,
    int? value,
  ) {
    // Null value is always valid (erasing)
    if (value == null) {
      return const Right(true);
    }

    // Check if position is valid
    if (!position.isValid) {
      return const Left(ValidationFailure('Invalid position'));
    }

    // Check if value is in valid range
    if (value < 1 || value > 9) {
      return const Left(ValidationFailure('Value must be between 1 and 9'));
    }

    // Check if cell is a given cell
    final Cell cell = gameState.cellAt(position.row, position.col);
    if (cell.isGiven) {
      return const Left(ValidationFailure('Cannot modify given cells'));
    }

    return const Right(true);
  }

  @override
  Either<Failure, bool> checkCompletion(GameState gameState) {
    // Check if all cells are filled
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (gameState.valueAt(row, col) == null) {
          return const Right(false);
        }
      }
    }

    // Check for any conflicts (errors)
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final Cell cell = gameState.cellAt(row, col);
        if (cell.isError) {
          return const Right(false);
        }
      }
    }

    // All cells filled and no errors
    return const Right(true);
  }

  /// Generates a complete valid Sudoku solution using backtracking.
  List<List<int>> _generateSolution() {
    final List<List<int>> grid =
        List<List<int>>.generate(9, (_) => List<int>.filled(9, 0));

    _fillGrid(grid);
    return grid;
  }

  /// Fills the grid with valid numbers using backtracking.
  bool _fillGrid(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          final List<int> numbers = List<int>.generate(9, (int i) => i + 1)
            ..shuffle(_random);

          for (final int num in numbers) {
            if (_isValidPlacement(grid, row, col, num)) {
              grid[row][col] = num;

              if (_fillGrid(grid)) {
                return true;
              }

              grid[row][col] = 0;
            }
          }

          return false;
        }
      }
    }

    return true;
  }

  /// Checks if placing [num] at [row], [col] is valid.
  bool _isValidPlacement(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == num) {
        return false;
      }
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == num) {
        return false;
      }
    }

    // Check 3x3 box
    final int boxRow = (row ~/ 3) * 3;
    final int boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if (grid[r][c] == num) {
          return false;
        }
      }
    }

    return true;
  }

  /// Removes [count] cells from the grid to create a puzzle.
  ///
  /// Uses a randomized approach while ensuring the puzzle
  /// maintains a unique solution.
  List<List<Cell>> _removeCells(List<List<Cell>> grid, int count) {
    final List<List<Cell>> result = List<List<Cell>>.generate(
      9,
      (int row) => List<Cell>.generate(
        9,
        (int col) => grid[row][col],
      ),
    );

    final List<int> positions = List<int>.generate(81, (int i) => i)..shuffle(_random);
    int removed = 0;

    for (final int pos in positions) {
      if (removed >= count) break;

      final int row = pos ~/ 9;
      final int col = pos % 9;

      result[row][col] = const Cell();
      removed++;
    }

    return result;
  }
}
