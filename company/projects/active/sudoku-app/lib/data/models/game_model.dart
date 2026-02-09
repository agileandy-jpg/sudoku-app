/// Game model for JSON serialization.
///
/// Represents the complete game state for data transfer.
library;

import '../../domain/entities/entities.dart';
import 'cell_model.dart';
import 'position_model.dart';

/// {@template game_model}
/// Model class for serializing and deserializing [GameState] entities.
///
/// Converts between [GameState] domain entities and JSON-compatible maps.
/// Used for persisting game state to local storage.
/// {@endtemplate}
class GameModel {
  /// {@macro game_model}
  const GameModel({
    required this.grid,
    required this.difficulty,
    required this.elapsedSeconds,
    required this.isCompleted,
    required this.moveCount,
    required this.score,
    this.selectedPosition,
    this.lastSaveTime,
  });

  /// Creates a [GameModel] from a domain [GameState] entity.
  ///
  /// [gameState] The domain entity to convert.
  factory GameModel.fromEntity(GameState gameState) {
    return GameModel(
      grid: gameState.grid
          .map(
            (List<Cell> row) =>
                row.map((Cell cell) => CellModel.fromEntity(cell)).toList(),
          )
          .toList(),
      difficulty: gameState.difficulty.name,
      elapsedSeconds: gameState.elapsedSeconds,
      isCompleted: gameState.isCompleted,
      moveCount: gameState.moveCount,
      score: gameState.score,
      selectedPosition: gameState.selectedPosition != null
          ? PositionModel.fromEntity(gameState.selectedPosition!)
          : null,
      lastSaveTime: gameState.lastSaveTime?.toIso8601String(),
    );
  }

  /// Creates a [GameModel] from a JSON map.
  ///
  /// [json] The JSON map to deserialize.
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      grid: (json['grid'] as List<dynamic>)
          .map(
            (dynamic row) => (row as List<dynamic>)
                .map(
                  (dynamic cell) =>
                      CellModel.fromJson(cell as Map<String, dynamic>),
                )
                .toList(),
          )
          .toList(),
      difficulty: json['difficulty'] as String,
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      moveCount: json['moveCount'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
      selectedPosition: json['selectedPosition'] != null
          ? PositionModel.fromJson(
              json['selectedPosition'] as Map<String, dynamic>,
            )
          : null,
      lastSaveTime: json['lastSaveTime'] as String?,
    );
  }

  /// The 9x9 grid of cell models.
  final List<List<CellModel>> grid;

  /// The difficulty level name.
  final String difficulty;

  /// Time elapsed in seconds.
  final int elapsedSeconds;

  /// True if the puzzle has been completed.
  final bool isCompleted;

  /// Number of moves made by the player.
  final int moveCount;

  /// Current score.
  final int score;

  /// Currently selected cell position, or null if none selected.
  final PositionModel? selectedPosition;

  /// When the game was last saved, as ISO 8601 string, or null.
  final String? lastSaveTime;

  /// Converts this model to a domain [GameState] entity.
  GameState toEntity() {
    return GameState(
      grid: grid
          .map(
            (List<CellModel> row) =>
                row.map((CellModel cell) => cell.toEntity()).toList(),
          )
          .toList(),
      difficulty: _parseDifficulty(difficulty),
      elapsedSeconds: elapsedSeconds,
      isCompleted: isCompleted,
      moveCount: moveCount,
      score: score,
      selectedPosition: selectedPosition?.toEntity(),
      lastSaveTime:
          lastSaveTime != null ? DateTime.parse(lastSaveTime!) : null,
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'grid': grid
          .map(
            (List<CellModel> row) =>
                row.map((CellModel cell) => cell.toJson()).toList(),
          )
          .toList(),
      'difficulty': difficulty,
      'elapsedSeconds': elapsedSeconds,
      'isCompleted': isCompleted,
      'moveCount': moveCount,
      'score': score,
      'selectedPosition': selectedPosition?.toJson(),
      'lastSaveTime': lastSaveTime,
    };
  }

  /// Parses a difficulty string into a [Difficulty] enum value.
  Difficulty _parseDifficulty(String name) {
    return Difficulty.values.firstWhere(
      (Difficulty d) => d.name == name,
      orElse: () => Difficulty.medium,
    );
  }
}
