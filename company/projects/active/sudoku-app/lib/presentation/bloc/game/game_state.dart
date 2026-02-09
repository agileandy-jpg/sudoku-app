/// Game BLoC states.
///
/// Represents all possible states of the game feature.
library;

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

/// {@template game_state}
/// Base class for all game states.
/// {@endtemplate}
abstract class GameBlocState extends Equatable {
  /// {@macro game_state}
  const GameBlocState();

  @override
  List<Object?> get props => [];
}

/// {@template game_initial}
/// Initial state before any game is loaded.
/// {@endtemplate}
class GameInitial extends GameBlocState {
  /// {@macro game_initial}
  const GameInitial();
}

/// {@template game_loading}
/// State when loading a game.
/// {@endtemplate}
class GameLoading extends GameBlocState {
  /// {@macro game_loading}
  const GameLoading();
}

/// {@template game_active}
/// State representing an active game in progress.
/// {@endtemplate}
class GameActive extends GameBlocState {
  /// {@macro game_active}
  const GameActive({
    required this.gameState,
    this.canUndo = false,
    this.canRedo = false,
    this.isNoteMode = false,
  });

  /// The current game state.
  final GameState gameState;

  /// Whether there are moves to undo.
  final bool canUndo;

  /// Whether there are moves to redo.
  final bool canRedo;

  /// Whether the user is in note/pencil mark mode.
  final bool isNoteMode;

  @override
  List<Object?> get props => [
        gameState,
        canUndo,
        canRedo,
        isNoteMode,
      ];

  /// Creates a copy of this state with the given fields replaced.
  GameActive copyWith({
    GameState? gameState,
    bool? canUndo,
    bool? canRedo,
    bool? isNoteMode,
  }) {
    return GameActive(
      gameState: gameState ?? this.gameState,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      isNoteMode: isNoteMode ?? this.isNoteMode,
    );
  }
}

/// {@template game_paused}
/// State when the game is paused.
/// {@endtemplate}
class GamePaused extends GameBlocState {
  /// {@macro game_paused}
  const GamePaused({
    required this.gameState,
    required this.canUndo,
    required this.canRedo,
  });

  /// The game state at pause time.
  final GameState gameState;

  /// Whether there are moves to undo.
  final bool canUndo;

  /// Whether there are moves to redo.
  final bool canRedo;

  @override
  List<Object?> get props => [gameState, canUndo, canRedo];
}

/// {@template game_over}
/// State when the game is completed.
/// {@endtemplate}
class GameOver extends GameBlocState {
  /// {@macro game_over}
  const GameOver({
    required this.gameState,
    required this.finalScore,
    required this.elapsedTime,
  });

  /// The final game state.
  final GameState gameState;

  /// The final score achieved.
  final int finalScore;

  /// The total time taken to complete.
  final Duration elapsedTime;

  @override
  List<Object?> get props => [gameState, finalScore, elapsedTime];
}

/// {@template game_error}
/// State when an error occurs.
/// {@endtemplate}
class GameError extends GameBlocState {
  /// {@macro game_error}
  const GameError({
    required this.message,
    this.previousState,
  });

  /// The error message to display.
  final String message;

  /// The previous state before the error, if any.
  final GameBlocState? previousState;

  @override
  List<Object?> get props => [message, previousState];
}
