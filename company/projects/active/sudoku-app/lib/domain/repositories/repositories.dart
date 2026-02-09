/// Repository interfaces for the domain layer.
library;

import 'package:dartz/dartz.dart';

import '../entities/entities.dart';
import '../failures/failures.dart';

/// {@template game_repository}
/// Repository interface for game-related operations.
/// 
/// This abstract class defines the contract for all game data operations,
/// including puzzle generation, saving/loading games, and move management.
/// 
/// Implementations should handle the actual data persistence and retrieval
/// while this interface remains pure and testable.
/// 
/// All methods return [Either] types to support functional error handling.
/// {@endtemplate}
abstract class GameRepository {
  /// {@template generate_puzzle}
  /// Generates a new Sudoku puzzle with the specified difficulty.
  /// 
  /// [difficulty] The difficulty level for the puzzle.
  /// 
  /// Returns [Right] with a new [GameState] on success,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Future<Either<Failure, GameState>> generatePuzzle(Difficulty difficulty);

  /// {@template save_game}
  /// Saves the current game state to persistent storage.
  /// 
  /// [gameState] The game state to save.
  /// 
  /// Returns [Right] with void on success,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Future<Either<Failure, void>> saveGame(GameState gameState);

  /// {@template get_saved_game}
  /// Retrieves a previously saved game from storage.
  /// 
  /// Returns [Right] with the saved [GameState] if one exists,
  /// [Right] with null if no saved game exists,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Future<Either<Failure, GameState?>> getSavedGame();

  /// {@template clear_saved_game}
  /// Clears any saved game from storage.
  /// 
  /// Returns [Right] with void on success,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Future<Either<Failure, void>> clearSavedGame();

  /// {@template validate_move}
  /// Validates whether a move is legal according to Sudoku rules.
  /// 
  /// [gameState] The current game state.
  /// [position] The position where the move is being made.
  /// [value] The value being placed.
  /// 
  /// Returns [Right] with true if the move is valid,
  /// or [Left] with a [Failure] if the move is invalid.
  /// {@endtemplate}
  Either<Failure, bool> validateMove(
    GameState gameState,
    Position position,
    int? value,
  );

  /// {@template check_completion}
  /// Checks if the puzzle is completely and correctly solved.
  /// 
  /// [gameState] The current game state.
  /// 
  /// Returns [Right] with true if the puzzle is complete and valid,
  /// [Right] with false if incomplete or invalid,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Either<Failure, bool> checkCompletion(GameState gameState);
}

/// {@template settings_repository}
/// Repository interface for settings-related operations.
/// 
/// This abstract class defines the contract for all settings data operations,
/// including loading and saving user preferences.
/// 
/// All methods return [Either] types to support functional error handling.
/// {@endtemplate}
abstract class SettingsRepository {
  /// {@template get_settings}
  /// Loads user settings from persistent storage.
  /// 
  /// Returns [Right] with [Settings] on success,
  /// or [Left] with a [Failure] on error.
  /// 
  /// If no settings exist, returns default settings.
  /// {@endtemplate}
  Future<Either<Failure, Settings>> getSettings();

  /// {@template save_settings}
  /// Saves user settings to persistent storage.
  /// 
  /// [settings] The settings to save.
  /// 
  /// Returns [Right] with void on success,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Future<Either<Failure, void>> saveSettings(Settings settings);

  /// {@template reset_settings}
  /// Resets settings to their default values.
  /// 
  /// Returns [Right] with the default [Settings] on success,
  /// or [Left] with a [Failure] on error.
  /// {@endtemplate}
  Future<Either<Failure, Settings>> resetSettings();
}
