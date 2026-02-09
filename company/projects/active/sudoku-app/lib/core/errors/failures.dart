/// Error handling types and exceptions for the Sudoku application.
library;

import 'package:equatable/equatable.dart';

/// {@template failure}
/// Base class for all failures in the application.
/// 
/// Failures represent expected error conditions that can occur
/// during normal operation and should be handled gracefully.
/// 
/// Use [Failure] with the Either type from dartz for functional
/// error handling throughout the application.
/// 
/// Example:
/// ```dart
/// Future<Either<Failure, Game>> loadGame(String id) async {
///   try {
///     final game = await _dataSource.load(id);
///     return Right(game);
///   } on GameNotFoundException {
///     return Left(GameNotFoundFailure());
///   }
/// }
/// ```
/// {@endtemplate}
abstract class Failure extends Equatable {
  /// {@macro failure}
  const Failure(this.message);

  /// Human-readable error message suitable for display to users.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// {@template cache_failure}
/// Failure related to local cache/storage operations.
/// 
/// Occurs when reading from or writing to local storage fails.
/// {@endtemplate}
class CacheFailure extends Failure {
  /// {@macro cache_failure}
  const CacheFailure() : super('Failed to access local storage');
}

/// {@template game_not_found_failure}
/// Failure when a requested game cannot be found in storage.
/// {@endtemplate}
class GameNotFoundFailure extends Failure {
  /// {@macro game_not_found_failure}
  const GameNotFoundFailure() : super('Game not found');
}

/// {@template invalid_move_failure}
/// Failure when a player attempts an invalid move.
/// {@endtemplate}
class InvalidMoveFailure extends Failure {
  /// {@macro invalid_move_failure}
  const InvalidMoveFailure() : super('Invalid move');
}

/// {@template puzzle_generation_failure}
/// Failure when puzzle generation fails.
/// {@endtemplate}
class PuzzleGenerationFailure extends Failure {
  /// {@macro puzzle_generation_failure}
  const PuzzleGenerationFailure() : super('Failed to generate puzzle');
}

/// {@template validation_failure}
/// Failure when input validation fails.
/// {@endtemplate}
class ValidationFailure extends Failure {
  /// {@macro validation_failure}
  const ValidationFailure(super.message);
}

/// {@template undo_failure}
/// Failure when undo operation cannot be performed.
/// {@endtemplate}
class UndoFailure extends Failure {
  /// {@macro undo_failure}
  const UndoFailure() : super('Nothing to undo');
}

/// {@template redo_failure}
/// Failure when redo operation cannot be performed.
/// {@endtemplate}
class RedoFailure extends Failure {
  /// {@macro redo_failure}
  const RedoFailure() : super('Nothing to redo');
}

/// {@template settings_failure}
/// Failure when settings operations fail.
/// {@endtemplate}
class SettingsFailure extends Failure {
  /// {@macro settings_failure}
  const SettingsFailure() : super('Failed to load or save settings');
}

/// {@template sudoku_exception}
/// Base class for Sudoku-specific exceptions.
/// 
/// These exceptions are used internally and should be caught
/// and converted to appropriate [Failure] types at repository boundaries.
/// {@endtemplate}
abstract class SudokuException implements Exception {
  /// {@macro sudoku_exception}
  const SudokuException(this.message);

  /// Error message describing what went wrong.
  final String message;
}

/// {@template invalid_cell_exception}
/// Exception thrown when an invalid cell position is accessed.
/// {@endtemplate}
class InvalidCellException extends SudokuException {
  /// {@macro invalid_cell_exception}
  InvalidCellException({required int row, required int col})
      : super('Invalid cell position: ($row, $col)');
}

/// {@template invalid_value_exception}
/// Exception thrown when an invalid value is assigned to a cell.
/// {@endtemplate}
class InvalidValueException extends SudokuException {
  /// {@macro invalid_value_exception}
  InvalidValueException(int value)
      : super('Invalid cell value: $value (must be 1-9 or 0 for empty)');
}

/// {@template puzzle_unsolvable_exception}
/// Exception thrown when a puzzle is determined to be unsolvable.
/// {@endtemplate}
class PuzzleUnsolvableException extends SudokuException {
  /// {@macro puzzle_unsolvable_exception}
  const PuzzleUnsolvableException() : super('Puzzle has no solution');
}
