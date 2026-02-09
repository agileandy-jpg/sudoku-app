/// Domain entities for the Sudoku application.
library;

import 'package:equatable/equatable.dart';

/// {@template cell}
/// Represents a single cell in the Sudoku grid.
/// 
/// A cell can be empty (value is null) or contain a number (1-9).
/// Cells can be either given (part of the original puzzle) or
/// user-entered. Cells can also contain pencil marks (notes).
/// 
/// Cells are immutable - use [copyWith] to create modified copies.
/// 
/// Example:
/// ```dart
/// const cell = Cell(
///   value: 5,
///   isGiven: true,
///   notes: {},
///   isError: false,
/// );
/// 
/// final modifiedCell = cell.copyWith(value: 3);
/// ```
/// {@endtemplate}
class Cell extends Equatable {
  /// {@macro cell}
  const Cell({
    this.value,
    this.isGiven = false,
    this.notes = const <int>{},
    this.isError = false,
  });

  /// The numeric value of the cell (1-9), or null if empty.
  final int? value;

  /// True if this cell is part of the original puzzle (cannot be changed).
  final bool isGiven;

  /// Set of pencil marks/notes for this cell.
  final Set<int> notes;

  /// True if this cell conflicts with Sudoku rules.
  final bool isError;

  /// Returns true if the cell is empty (has no value).
  bool get isEmpty => value == null;

  /// Returns true if the cell has a value.
  bool get isFilled => value != null;

  /// Returns true if the cell has any notes.
  bool get hasNotes => notes.isNotEmpty;

  /// Creates a copy of this cell with the given fields replaced.
  /// 
  /// Example:
  /// ```dart
  /// final newCell = cell.copyWith(value: 5);
  /// ```
  Cell copyWith({
    int? value,
    bool? isGiven,
    Set<int>? notes,
    bool? isError,
    bool clearValue = false,
  }) {
    return Cell(
      value: clearValue ? null : (value ?? this.value),
      isGiven: isGiven ?? this.isGiven,
      notes: notes ?? this.notes,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [value, isGiven, notes, isError];
}

/// {@template difficulty}
/// Enum representing the difficulty levels of Sudoku puzzles.
/// 
/// Each difficulty level has a specific number of given cells:
/// - Easy: 35 cells given
/// - Medium: 30 cells given
/// - Hard: 25 cells given
/// - Expert: 22 cells given
/// 
/// Example:
/// ```dart
/// final difficulty = Difficulty.medium;
/// print(difficulty.label); // "Medium"
/// print(difficulty.givenCells); // 30
/// ```
/// {@endtemplate}
enum Difficulty {
  /// Easy difficulty with 35 given cells.
  easy._('Easy', 35, 300), // 5 min target

  /// Medium difficulty with 30 given cells.
  medium._('Medium', 30, 600), // 10 min target

  /// Hard difficulty with 25 given cells.
  hard._('Hard', 25, 1200), // 20 min target

  /// Expert difficulty with 22 given cells.
  expert._('Expert', 22, 2400); // 40 min target

  const Difficulty._(this.label, this.givenCells, this.targetTimeSeconds);

  /// Human-readable label for the difficulty.
  final String label;

  /// Number of cells that are pre-filled in puzzles of this difficulty.
  final int givenCells;

  /// Target solve time in seconds (for scoring).
  final int targetTimeSeconds;

  /// Estimated solve time formatted as a string.
  String get estimatedTime {
    if (targetTimeSeconds < 60) {
      return '${targetTimeSeconds}s';
    }
    final int minutes = targetTimeSeconds ~/ 60;
    return '~$minutes min';
  }
}

/// {@template position}
/// Represents a position in the Sudoku grid.
/// 
/// Both row and column are 0-indexed (0-8).
/// 
/// Example:
/// ```dart
/// const pos = Position(row: 0, col: 0); // Top-left corner
/// const center = Position(row: 4, col: 4); // Center cell
/// ```
/// {@endtemplate}
class Position extends Equatable {
  /// {@macro position}
  const Position({required this.row, required this.col});

  /// Row index (0-8, top to bottom).
  final int row;

  /// Column index (0-8, left to right).
  final int col;

  /// Returns true if this position is valid (within the 9x9 grid).
  bool get isValid => row >= 0 && row < 9 && col >= 0 && col < 9;

  @override
  List<Object?> get props => [row, col];
}

/// {@template game_state}
/// Represents the complete state of a Sudoku game.
/// 
/// Contains the grid, difficulty, timer state, move history,
/// and other metadata about the current game session.
/// 
/// GameState is immutable - use [copyWith] to create modified copies.
/// 
/// Example:
/// ```dart
/// final game = GameState(
///   grid: initialGrid,
///   difficulty: Difficulty.medium,
///   isCompleted: false,
/// );
/// ```
/// {@endtemplate}
class GameState extends Equatable {
  /// {@macro game_state}
  const GameState({
    required this.grid,
    required this.difficulty,
    this.elapsedSeconds = 0,
    this.isCompleted = false,
    this.moveCount = 0,
    this.score = 0,
    this.selectedPosition,
    this.lastSaveTime,
  });

  /// The 9x9 grid of cells.
  final List<List<Cell>> grid;

  /// The difficulty level of this game.
  final Difficulty difficulty;

  /// Time elapsed in seconds.
  final int elapsedSeconds;

  /// True if the puzzle has been completed.
  final bool isCompleted;

  /// Number of moves made by the player.
  final int moveCount;

  /// Current score (calculated based on time and difficulty).
  final int score;

  /// Currently selected cell position, or null if none selected.
  final Position? selectedPosition;

  /// When the game was last saved, or null if never saved.
  final DateTime? lastSaveTime;

  /// Returns the cell at the given position.
  /// 
  /// [row] The row index (0-8).
  /// [col] The column index (0-8).
  /// 
  /// Returns the [Cell] at that position.
  Cell cellAt(int row, int col) => grid[row][col];

  /// Returns the value at the given position, or null if empty.
  /// 
  /// [row] The row index (0-8).
  /// [col] The column index (0-8).
  int? valueAt(int row, int col) => grid[row][col].value;

  /// Returns the elapsed time as a [Duration].
  Duration get elapsedDuration => Duration(seconds: elapsedSeconds);

  /// Returns the number of empty cells remaining.
  int get emptyCellCount {
    int count = 0;
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col].isEmpty) {
          count++;
        }
      }
    }
    return count;
  }

  /// Returns true if the game is currently active (not completed).
  bool get isActive => !isCompleted;

  /// Creates a copy of this game state with the given fields replaced.
  GameState copyWith({
    List<List<Cell>>? grid,
    Difficulty? difficulty,
    int? elapsedSeconds,
    bool? isCompleted,
    int? moveCount,
    int? score,
    Position? selectedPosition,
    DateTime? lastSaveTime,
    bool clearSelectedPosition = false,
  }) {
    return GameState(
      grid: grid ?? this.grid,
      difficulty: difficulty ?? this.difficulty,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      moveCount: moveCount ?? this.moveCount,
      score: score ?? this.score,
      selectedPosition: clearSelectedPosition
          ? null
          : (selectedPosition ?? this.selectedPosition),
      lastSaveTime: lastSaveTime ?? this.lastSaveTime,
    );
  }

  @override
  List<Object?> get props => [
        grid,
        difficulty,
        elapsedSeconds,
        isCompleted,
        moveCount,
        score,
        selectedPosition,
        lastSaveTime,
      ];
}

/// {@template move}
/// Represents a single move made by the player.
/// 
/// Stores the position, previous value, and new value to enable
/// undo/redo functionality.
/// 
/// Example:
/// ```dart
/// final move = Move(
///   position: Position(row: 0, col: 0),
///   previousValue: null,
///   newValue: 5,
///   wasNote: false,
/// );
/// ```
/// {@endtemplate}
class Move extends Equatable {
  /// {@macro move}
  const Move({
    required this.position,
    required this.previousValue,
    required this.newValue,
    required this.wasNote,
    this.previousNotes = const <int>{},
  });

  /// The position where the move was made.
  final Position position;

  /// The value before the move (null if empty).
  final int? previousValue;

  /// The value after the move (null if erased).
  final int? newValue;

  /// True if this move was made in note/pencil mark mode.
  final bool wasNote;

  /// The notes before the move (only relevant for note operations).
  final Set<int> previousNotes;

  /// Returns true if this move changed a cell value (not a note).
  bool get isValueChange => !wasNote;

  /// Returns true if this move erased a value.
  bool get isErase => newValue == null && previousValue != null;

  @override
  List<Object?> get props => [
        position,
        previousValue,
        newValue,
        wasNote,
        previousNotes,
      ];
}

/// {@template settings}
/// User preferences and settings for the Sudoku app.
/// 
/// Settings are immutable - use [copyWith] to create modified copies.
/// 
/// Example:
/// ```dart
/// final settings = Settings(
///   themeMode: ThemeMode.system,
///   showTimer: true,
///   autoCheckErrors: true,
/// );
/// ```
/// {@endtemplate}
class Settings extends Equatable {
  /// {@macro settings}
  const Settings({
    this.themeMode = ThemeMode.system,
    this.showTimer = true,
    this.autoCheckErrors = true,
    this.enableHaptic = true,
    this.soundEnabled = true,
    this.lastDifficulty = Difficulty.medium,
  });

  /// The selected theme mode.
  final ThemeMode themeMode;

  /// Whether to show the game timer.
  final bool showTimer;

  /// Whether to automatically highlight errors.
  final bool autoCheckErrors;

  /// Whether to enable haptic feedback.
  final bool enableHaptic;

  /// Whether sound effects are enabled.
  final bool soundEnabled;

  /// The last selected difficulty.
  final Difficulty lastDifficulty;

  /// Creates a copy of this settings with the given fields replaced.
  Settings copyWith({
    ThemeMode? themeMode,
    bool? showTimer,
    bool? autoCheckErrors,
    bool? enableHaptic,
    bool? soundEnabled,
    Difficulty? lastDifficulty,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      showTimer: showTimer ?? this.showTimer,
      autoCheckErrors: autoCheckErrors ?? this.autoCheckErrors,
      enableHaptic: enableHaptic ?? this.enableHaptic,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      lastDifficulty: lastDifficulty ?? this.lastDifficulty,
    );
  }

  @override
  List<Object?> get props => [
        themeMode,
        showTimer,
        autoCheckErrors,
        enableHaptic,
        soundEnabled,
        lastDifficulty,
      ];
}

/// Theme mode options for the app.
enum ThemeMode {
  /// Use system theme setting.
  system,

  /// Always use light theme.
  light,

  /// Always use dark theme.
  dark,
}
