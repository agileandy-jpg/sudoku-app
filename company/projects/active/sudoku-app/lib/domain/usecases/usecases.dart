/// Domain use cases for the Sudoku application.
library;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../entities/entities.dart';
import '../failures/failures.dart';
import '../repositories/repositories.dart';

/// {@template usecase}
/// Base class for all use cases.
/// 
/// Use cases represent single-responsibility operations that can be
/// executed by the presentation layer. Each use case should do one
/// thing and do it well.
/// 
/// [Type] The return type of the use case.
/// [Params] The parameters required to execute the use case.
/// {@endtemplate}
abstract class UseCase<Type, Params> {
  /// {@macro usecase}
  const UseCase();

  /// Executes the use case with the given parameters.
  /// 
  /// Returns [Either] with [Failure] on error or [Type] on success.
  Future<Either<Failure, Type>> call(Params params);
}

/// {@template no_params}
/// Represents no parameters for a use case.
/// 
/// Use this when a use case doesn't require any input parameters.
/// {@endtemplate}
class NoParams extends Equatable {
  /// {@macro no_params}
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// {@template generate_puzzle}
/// Use case for generating a new Sudoku puzzle.
/// 
/// Generates a valid, solvable Sudoku puzzle with the specified difficulty.
/// {@endtemplate}
class GeneratePuzzle extends UseCase<GameState, Difficulty> {
  /// {@macro generate_puzzle}
  const GeneratePuzzle(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, GameState>> call(Difficulty difficulty) async {
    return _repository.generatePuzzle(difficulty);
  }
}

/// {@template make_move_params}
/// Parameters for the [MakeMove] use case.
/// {@endtemplate}
class MakeMoveParams extends Equatable {
  /// {@macro make_move_params}
  const MakeMoveParams({
    required this.gameState,
    required this.position,
    required this.value,
  });

  /// The current game state.
  final GameState gameState;

  /// The position where the move is being made.
  final Position position;

  /// The value to place (null to erase).
  final int? value;

  @override
  List<Object?> get props => [gameState, position, value];
}

/// {@template make_move}
/// Use case for making a move in the game.
/// 
/// Updates the game state with a new value at the specified position,
/// validates the move, and checks for game completion.
/// {@endtemplate}
class MakeMove extends UseCase<GameState, MakeMoveParams> {
  /// {@macro make_move}
  const MakeMove(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, GameState>> call(MakeMoveParams params) async {
    // Validate the move
    final Either<Failure, bool> validationResult = _repository.validateMove(
      params.gameState,
      params.position,
      params.value,
    );

    return validationResult.fold(
      (Failure failure) => Left(failure),
      (bool isValid) async {
        if (!isValid) {
          return const Left(InvalidMoveFailure());
        }

        // Create new grid with the move applied
        final List<List<Cell>> newGrid = _updateGrid(
          params.gameState.grid,
          params.position,
          params.value,
        );

        // Check for conflicts if auto-check is enabled
        final List<List<Cell>> validatedGrid = _validateGrid(newGrid);

        // Create updated game state
        GameState newState = params.gameState.copyWith(
          grid: validatedGrid,
          moveCount: params.gameState.moveCount + 1,
          selectedPosition: params.position,
        );

        // Check for completion
        final Either<Failure, bool> completionResult =
            _repository.checkCompletion(newState);

        return completionResult.fold(
          (Failure failure) => Left(failure),
          (bool isComplete) {
            if (isComplete) {
              newState = newState.copyWith(isCompleted: true);
              // Calculate score
              final int score = _calculateScore(newState);
              newState = newState.copyWith(score: score);
            }
            return Right(newState);
          },
        );
      },
    );
  }

  List<List<Cell>> _updateGrid(
    List<List<Cell>> grid,
    Position position,
    int? value,
  ) {
    final List<List<Cell>> newGrid = List<List<Cell>>.generate(
      9,
      (int row) => List<Cell>.generate(
        9,
        (int col) => grid[row][col],
      ),
    );

    final Cell currentCell = newGrid[position.row][position.col];
    if (!currentCell.isGiven) {
      newGrid[position.row][position.col] = currentCell.copyWith(value: value);
    }

    return newGrid;
  }

  List<List<Cell>> _validateGrid(List<List<Cell>> grid) {
    final List<List<Cell>> validatedGrid = List<List<Cell>>.generate(
      9,
      (int row) => List<Cell>.generate(
        9,
        (int col) => grid[row][col],
      ),
    );

    // Check each cell for conflicts
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        final Cell cell = validatedGrid[row][col];
        if (cell.value != null) {
          final bool hasConflict = _hasConflict(validatedGrid, row, col, cell.value!);
          if (hasConflict != cell.isError) {
            validatedGrid[row][col] = cell.copyWith(isError: hasConflict);
          }
        }
      }
    }

    return validatedGrid;
  }

  bool _hasConflict(List<List<Cell>> grid, int row, int col, int value) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (c != col && grid[row][c].value == value) {
        return true;
      }
    }

    // Check column
    for (int r = 0; r < 9; r++) {
      if (r != row && grid[r][col].value == value) {
        return true;
      }
    }

    // Check 3x3 box
    final int boxRow = (row ~/ 3) * 3;
    final int boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if ((r != row || c != col) && grid[r][c].value == value) {
          return true;
        }
      }
    }

    return false;
  }

  int _calculateScore(GameState state) {
    // Base score based on difficulty
    final int baseScore = switch (state.difficulty) {
      Difficulty.easy => 100,
      Difficulty.medium => 200,
      Difficulty.hard => 400,
      Difficulty.expert => 800,
    };

    // Time bonus (faster = more points)
    final int targetTime = state.difficulty.targetTimeSeconds;
    final int timeBonus = targetTime > state.elapsedSeconds
        ? (targetTime - state.elapsedSeconds) * 2
        : 0;

    return baseScore + timeBonus;
  }
}

/// {@template undo_move}
/// Use case for undoing the last move.
/// 
/// Reverts the game state to the previous state from history.
/// {@endtemplate}
class UndoMove extends UseCase<GameState, GameState> {
  /// {@macro undo_move}
  const UndoMove(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, GameState>> call(GameState currentState) async {
    // Undo logic is handled in the BLoC with history management
    // This use case is a placeholder for repository-level undo if needed
    return Left(const UndoFailure());
  }
}

/// {@template redo_move}
/// Use case for redoing a previously undone move.
/// 
/// Reapplies a move that was previously undone.
/// {@endtemplate}
class RedoMove extends UseCase<GameState, GameState> {
  /// {@macro redo_move}
  const RedoMove(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, GameState>> call(GameState currentState) async {
    // Redo logic is handled in the BLoC with history management
    // This use case is a placeholder for repository-level redo if needed
    return Left(const RedoFailure());
  }
}

/// {@template toggle_note_params}
/// Parameters for the [ToggleNote] use case.
/// {@endtemplate}
class ToggleNoteParams extends Equatable {
  /// {@macro toggle_note_params}
  const ToggleNoteParams({
    required this.gameState,
    required this.position,
    required this.note,
  });

  /// The current game state.
  final GameState gameState;

  /// The position where to toggle the note.
  final Position position;

  /// The note value to toggle (1-9).
  final int note;

  @override
  List<Object?> get props => [gameState, position, note];
}

/// {@template toggle_note}
/// Use case for toggling a pencil mark (note) in a cell.
/// 
/// Adds or removes a note value from the specified cell.
/// {@endtemplate}
class ToggleNote extends UseCase<GameState, ToggleNoteParams> {
  /// {@macro toggle_note}
  const ToggleNote(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, GameState>> call(ToggleNoteParams params) async {
    final Cell cell = params.gameState.cellAt(
      params.position.row,
      params.position.col,
    );

    if (cell.isGiven || cell.value != null) {
      return const Left(InvalidMoveFailure());
    }

    final Set<int> newNotes = Set<int>.from(cell.notes);
    if (newNotes.contains(params.note)) {
      newNotes.remove(params.note);
    } else {
      newNotes.add(params.note);
    }

    final List<List<Cell>> newGrid = List<List<Cell>>.generate(
      9,
      (int row) => List<Cell>.generate(
        9,
        (int col) {
          if (row == params.position.row && col == params.position.col) {
            return cell.copyWith(notes: newNotes);
          }
          return params.gameState.grid[row][col];
        },
      ),
    );

    return Right(params.gameState.copyWith(grid: newGrid));
  }
}

/// {@template get_saved_game}
/// Use case for retrieving a saved game.
/// 
/// Loads the most recently saved game from storage.
/// {@endtemplate}
class GetSavedGame extends UseCase<GameState?, NoParams> {
  /// {@macro get_saved_game}
  const GetSavedGame(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, GameState?>> call(NoParams params) async {
    return _repository.getSavedGame();
  }
}

/// {@template save_game}
/// Use case for saving the current game.
/// 
/// Persists the current game state to storage.
/// {@endtemplate}
class SaveGame extends UseCase<void, GameState> {
  /// {@macro save_game}
  const SaveGame(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, void>> call(GameState gameState) async {
    return _repository.saveGame(gameState);
  }
}

/// {@template check_game_completion}
/// Use case for checking if the game is complete.
/// 
/// Validates that the puzzle is fully and correctly solved.
/// {@endtemplate}
class CheckGameCompletion extends UseCase<bool, GameState> {
  /// {@macro check_game_completion}
  const CheckGameCompletion(this._repository);

  final GameRepository _repository;

  @override
  Future<Either<Failure, bool>> call(GameState gameState) async {
    return _repository.checkCompletion(gameState);
  }
}
