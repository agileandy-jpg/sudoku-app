/// Position model for JSON serialization.
///
/// Represents a position in the Sudoku grid for data transfer.
library;

import '../../domain/entities/entities.dart';

/// {@template position_model}
/// Model class for serializing and deserializing [Position] entities.
///
/// Converts between [Position] domain entities and JSON-compatible maps.
/// {@endtemplate}
class PositionModel {
  /// {@macro position_model}
  const PositionModel({
    required this.row,
    required this.col,
  });

  /// Creates a [PositionModel] from a domain [Position] entity.
  ///
  /// [position] The domain entity to convert.
  factory PositionModel.fromEntity(Position position) {
    return PositionModel(
      row: position.row,
      col: position.col,
    );
  }

  /// Creates a [PositionModel] from a JSON map.
  ///
  /// [json] The JSON map to deserialize.
  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      row: json['row'] as int,
      col: json['col'] as int,
    );
  }

  /// Row index (0-8, top to bottom).
  final int row;

  /// Column index (0-8, left to right).
  final int col;

  /// Converts this model to a domain [Position] entity.
  Position toEntity() {
    return Position(
      row: row,
      col: col,
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'row': row,
      'col': col,
    };
  }
}
