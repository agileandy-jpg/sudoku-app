/// Game BLoC.
///
/// Manages game state and handles all game-related events.
library;

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/check_game_completion.dart';
import '../../../domain/usecases/generate_puzzle.dart';
import '../../../domain/usecases/get_saved_game.dart';
import '../../../domain/usecases/make_move.dart';
import '../../../domain/usecases/redo_move.dart';
import '../../../domain/usecases/save_game.dart';
import '../../../domain/usecases/toggle_note.dart';
import '../../../domain/usecases/undo_move.dart';
import 'game_event.dart';
import 'game_state.dart';

export 'game_event.dart';
export 'game_state.dart';

/// {@template game_bloc}
/// BLoC that manages Sudoku game state and logic.
///
/// Handles all game events including:
/// - Starting new games
/// - Loading saved games
/// - Making moves
/// - Undo/redo operations
/// - Timer management
/// - Win condition checking
///
/// Maintains a history of game states for undo/redo functionality.
/// {@endtemplate}
class GameBloc extends Bloc<GameEvent, GameBlocState> {
  /// {@macro game_bloc}
  GameBloc({
    required GeneratePuzzle generatePuzzle,
    required MakeMove makeMove,
    required UndoMove undoMove,
    required RedoMove redoMove,
    required ToggleNote toggleNote,
    required GetSavedGame getSavedGame,
    required SaveGame saveGame,
    required CheckGameCompletion checkGameCompletion,
  })  : _generatePuzzle = generatePuzzle,
        _makeMove = makeMove,
        _undoMove = undoMove,
        _redoMove = redoMove,
        _toggleNote = toggleNote,
        _getSavedGame = getSavedGame,
        _saveGame = saveGame,
        _checkGameCompletion = checkGameCompletion,
        super(const GameInitial()) {
    on<GameInitialized>(_onInitialized);
    on<NewGameStarted>(_onNewGameStarted);
    on<SavedGameLoaded>(_onSavedGameLoaded);
    on<CellSelected>(_onCellSelected);
    on<NumberEntered>(_onNumberEntered);
    on<CellCleared>(_onCellCleared);
    on<NoteToggled>(_onNoteToggled);
    on<UndoPressed>(_onUndoPressed);
    on<RedoPressed>(_onRedoPressed);
    on<TimerTicked>(_onTimerTicked);
    on<GameCompleted>(_onGameCompleted);
    on<GameSaved>(_onGameSaved);
  }

  final GeneratePuzzle _generatePuzzle;
  final MakeMove _makeMove;
  final UndoMove _undoMove;
  final RedoMove _redoMove;
  final ToggleNote _toggleNote;
  final GetSavedGame _getSavedGame;
  final SaveGame _saveGame;
  final CheckGameCompletion _checkGameCompletion;

  // History management for undo/redo
  final List<GameState> _history = [];
  int _historyIndex = -1;

  void _saveToHistory(GameState state) {
    // Remove any future states if we're not at the end
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(state);
    _historyIndex++;
  }

  Future<void> _onInitialized(
    GameInitialized event,
    Emitter<GameBlocState> emit,
  ) async {
    emit(const GameLoading());

    final result = await _getSavedGame(const NoParams());

    await result.fold(
      (Failure failure) async {
        emit(const GameInitial());
      },
      (GameState? gameState) async {
        if (gameState != null && !gameState.isCompleted) {
          _saveToHistory(gameState);
          emit(GameActive(
            gameState: gameState,
            canUndo: _historyIndex > 0,
            canRedo: false,
          ));
        } else {
          emit(const GameInitial());
        }
      },
    );
  }

  Future<void> _onNewGameStarted(
    NewGameStarted event,
    Emitter<GameBlocState> emit,
  ) async {
    emit(const GameLoading());

    final result = await _generatePuzzle(event.difficulty);

    await result.fold(
      (Failure failure) async {
        emit(GameError(message: failure.message));
      },
      (GameState gameState) async {
        _history.clear();
        _historyIndex = -1;
        _saveToHistory(gameState);
        emit(GameActive(
          gameState: gameState,
          canUndo: false,
          canRedo: false,
        ));
      },
    );
  }

  Future<void> _onSavedGameLoaded(
    SavedGameLoaded event,
    Emitter<GameBlocState> emit,
  ) async {
    emit(const GameLoading());

    final result = await _getSavedGame(const NoParams());

    await result.fold(
      (Failure failure) async {
        emit(GameError(message: failure.message));
      },
      (GameState? gameState) async {
        if (gameState != null) {
          _history.clear();
          _historyIndex = -1;
          _saveToHistory(gameState);
          emit(GameActive(
            gameState: gameState,
            canUndo: _historyIndex > 0,
            canRedo: false,
          ));
        } else {
          emit(const GameError(message: 'No saved game found'));
        }
      },
    );
  }

  Future<void> _onCellSelected(
    CellSelected event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;

    final GameActive currentState = state as GameActive;
    final GameState updatedGameState = currentState.gameState.copyWith(
      selectedPosition: event.position,
    );

    emit(currentState.copyWith(gameState: updatedGameState));
  }

  Future<void> _onNumberEntered(
    NumberEntered event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;

    final GameActive currentState = state as GameActive;
    final Position? selectedPosition = currentState.gameState.selectedPosition;

    if (selectedPosition == null) return;

    if (currentState.isNoteMode) {
      // Handle note mode
      if (event.value != null) {
        final result = await _toggleNote(
          ToggleNoteParams(
            gameState: currentState.gameState,
            position: selectedPosition,
            note: event.value!,
          ),
        );

        await result.fold(
          (Failure failure) async {
            // Note toggle failed, ignore
          },
          (GameState newState) async {
            _saveToHistory(newState);
            emit(currentState.copyWith(
              gameState: newState,
              canUndo: _historyIndex > 0,
              canRedo: false,
            ));
          },
        );
      }
    } else {
      // Handle value entry
      final result = await _makeMove(
        MakeMoveParams(
          gameState: currentState.gameState,
          position: selectedPosition,
          value: event.value,
        ),
      );

      await result.fold(
        (Failure failure) async {
          // Invalid move, ignore
        },
        (GameState newState) async {
          _saveToHistory(newState);
          final bool isComplete = await _checkCompletion(newState);

          if (isComplete) {
            await _saveGame(newState);
            emit(GameOver(
              gameState: newState,
              finalScore: newState.score,
              elapsedTime: newState.elapsedDuration,
            ));
          } else {
            emit(currentState.copyWith(
              gameState: newState,
              canUndo: _historyIndex > 0,
              canRedo: false,
            ));
          }
        },
      );
    }
  }

  Future<void> _onCellCleared(
    CellCleared event,
    Emitter<GameBlocState> emit,
  ) async {
    await _onNumberEntered(const NumberEntered(null), emit);
  }

  Future<void> _onNoteToggled(
    NoteToggled event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;

    final GameActive currentState = state as GameActive;

    final result = await _toggleNote(
      ToggleNoteParams(
        gameState: currentState.gameState,
        position: currentState.gameState.selectedPosition ??
            const Position(row: 0, col: 0),
        note: event.note,
      ),
    );

    await result.fold(
      (Failure failure) async {
        // Note toggle failed, ignore
      },
      (GameState newState) async {
        _saveToHistory(newState);
        emit(currentState.copyWith(
          gameState: newState,
          canUndo: _historyIndex > 0,
          canRedo: false,
        ));
      },
    );
  }

  Future<void> _onUndoPressed(
    UndoPressed event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;
    if (_historyIndex <= 0) return;

    _historyIndex--;
    final GameState previousState = _history[_historyIndex];
    final GameActive currentState = state as GameActive;

    emit(currentState.copyWith(
      gameState: previousState,
      canUndo: _historyIndex > 0,
      canRedo: _historyIndex < _history.length - 1,
    ));
  }

  Future<void> _onRedoPressed(
    RedoPressed event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;
    if (_historyIndex >= _history.length - 1) return;

    _historyIndex++;
    final GameState nextState = _history[_historyIndex];
    final GameActive currentState = state as GameActive;

    emit(currentState.copyWith(
      gameState: nextState,
      canUndo: _historyIndex > 0,
      canRedo: _historyIndex < _history.length - 1,
    ));
  }

  Future<void> _onTimerTicked(
    TimerTicked event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;

    final GameActive currentState = state as GameActive;
    final GameState updatedGameState = currentState.gameState.copyWith(
      elapsedSeconds: event.elapsedSeconds,
    );

    // Update history with new time
    _history[_historyIndex] = updatedGameState;

    emit(currentState.copyWith(gameState: updatedGameState));
  }

  Future<void> _onGameCompleted(
    GameCompleted event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;

    final GameActive currentState = state as GameActive;
    final GameState gameState = currentState.gameState;

    await _saveGame(gameState);

    emit(GameOver(
      gameState: gameState,
      finalScore: gameState.score,
      elapsedTime: gameState.elapsedDuration,
    ));
  }

  Future<void> _onGameSaved(
    GameSaved event,
    Emitter<GameBlocState> emit,
  ) async {
    if (state is! GameActive) return;

    final GameActive currentState = state as GameActive;
    final result = await _saveGame(currentState.gameState);

    result.fold(
      (Failure failure) {
        emit(GameError(
          message: 'Failed to save game: ${failure.message}',
          previousState: currentState,
        ));
      },
      (_) {
        // Game saved successfully
      },
    );
  }

  Future<bool> _checkCompletion(GameState gameState) async {
    final result = await _checkGameCompletion(gameState);
    return result.fold(
      (Failure failure) => false,
      (bool isComplete) => isComplete,
    );
  }
}

/// Placeholder for NoParams.
class NoParams {
  /// Creates a NoParams instance.
  const NoParams();
}
