/// Game BLoC events.
///
/// Defines all user actions that can trigger game state changes.
library;

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

/// {@template game_event}
/// Base class for all game events.
/// {@endtemplate}
abstract class GameEvent extends Equatable {
  /// {@macro game_event}
  const GameEvent();

  @override
  List<Object?> get props => [];
}

/// {@template game_initialized}
/// Event triggered when the game feature is initialized.
/// {@endtemplate}
class GameInitialized extends GameEvent {
  /// {@macro game_initialized}
  const GameInitialized();
}

/// {@template new_game_started}
/// Event triggered when a new game is started.
/// {@endtemplate}
class NewGameStarted extends GameEvent {
  /// {@macro new_game_started}
  const NewGameStarted({
    this.difficulty = Difficulty.medium,
  });

  /// The difficulty level for the new game.
  final Difficulty difficulty;

  @override
  List<Object?> get props => [difficulty];
}

/// {@template saved_game_loaded}
/// Event triggered when attempting to load a saved game.
/// {@endtemplate}
class SavedGameLoaded extends GameEvent {
  /// {@macro saved_game_loaded}
  const SavedGameLoaded();
}

/// {@template cell_selected}
/// Event triggered when a cell is selected.
/// {@endtemplate}
class CellSelected extends GameEvent {
  /// {@macro cell_selected}
  const CellSelected(this.position);

  /// The position of the selected cell.
  final Position position;

  @override
  List<Object?> get props => [position];
}

/// {@template number_entered}
/// Event triggered when a number is entered in a cell.
/// {@endtemplate}
class NumberEntered extends GameEvent {
  /// {@macro number_entered}
  const NumberEntered(this.value);

  /// The value entered (1-9), or null to clear.
  final int? value;

  @override
  List<Object?> get props => [value];
}

/// {@template cell_cleared}
/// Event triggered when the current cell is cleared.
/// {@endtemplate}
class CellCleared extends GameEvent {
  /// {@macro cell_cleared}
  const CellCleared();
}

/// {@template note_toggled}
/// Event triggered when a note/pencil mark is toggled.
/// {@endtemplate}
class NoteToggled extends GameEvent {
  /// {@macro note_toggled}
  const NoteToggled(this.note);

  /// The note value to toggle (1-9).
  final int note;

  @override
  List<Object?> get props => [note];
}

/// {@template undo_pressed}
/// Event triggered when the user requests to undo the last move.
/// {@endtemplate}
class UndoPressed extends GameEvent {
  /// {@macro undo_pressed}
  const UndoPressed();
}

/// {@template redo_pressed}
/// Event triggered when the user requests to redo a move.
/// {@endtemplate}
class RedoPressed extends GameEvent {
  /// {@macro redo_pressed}
  const RedoPressed();
}

/// {@template timer_ticked}
/// Event triggered by the timer to update elapsed time.
/// {@endtemplate}
class TimerTicked extends GameEvent {
  /// {@macro timer_ticked}
  const TimerTicked(this.elapsedSeconds);

  /// The total elapsed seconds.
  final int elapsedSeconds;

  @override
  List<Object?> get props => [elapsedSeconds];
}

/// {@template game_completed}
/// Event triggered when the game is completed.
/// {@endtemplate}
class GameCompleted extends GameEvent {
  /// {@macro game_completed}
  const GameCompleted();
}

/// {@template game_saved}
/// Event triggered when the user requests to save the game.
/// {@endtemplate}
class GameSaved extends GameEvent {
  /// {@macro game_saved}
  const GameSaved();
}

/// {@template hint_requested}
/// Event triggered when the user requests a hint.
/// {@endtemplate}
class HintRequested extends GameEvent {
  /// {@macro hint_requested}
  const HintRequested();
}
