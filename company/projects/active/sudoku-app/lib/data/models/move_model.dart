/// Move model for JSON serialization.
///
/// Represents a single move for data transfer.
library;

import '../../domain/entities/entities.dart';
import 'position_model.dart';

/// {@template move_model}
/// Model class for serializing and deserializing [Move] entities.
///
/// Converts between [Move] domain entities and JSON-compatible maps.
/// {@endtemplate}
class MoveModel {
  /// {@macro move_model}
  const MoveModel({
    required this.position,
    this.previousValue,
    this.newValue,
    required this.wasNote,
    required this.previousNotes,
  });

  /// Creates a [MoveModel] from a domain [Move] entity.
  ///
  /// [move] The domain entity to convert.
  factory MoveModel.fromEntity(Move move) {
    return MoveModel(
      position: PositionModel.fromEntity(move.position),
      previousValue: move.previousValue,
      newValue: move.newValue,
      wasNote: move.wasNote,
      previousNotes: move.previousNotes.toList(),
    );
  }

  /// Creates a [MoveModel] from a JSON map.
  ///
  /// [json] The JSON map to deserialize.
  factory MoveModel.fromJson(Map<String, dynamic> json) {
    return MoveModel(
      position: PositionModel.fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      previousValue: json['previousValue'] as int?,
      newValue: json['newValue'] as int?,
      wasNote: json['wasNote'] as bool? ?? false,
      previousNotes: (json['previousNotes'] as List<dynamic>?)
              ?.map((dynamic e) => e as int)
              .toList() ??
          <int>[],
    );
  }

  /// The position where the move was made.
  final PositionModel position;

  /// The value before the move (null if empty).
  final int? previousValue;

  /// The value after the move (null if erased).
  final int? newValue;

  /// True if this move was made in note/pencil mark mode.
  final bool wasNote;

  /// The notes before the move.
  final List<int> previousNotes;

  /// Converts this model to a domain [Move] entity.
  Move toEntity() {
    return Move(
      position: position.toEntity(),
      previousValue: previousValue,
      newValue: newValue,
      wasNote: wasNote,
      previousNotes: previousNotes.toSet(),
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'position': position.toJson(),
      'previousValue': previousValue,
      'newValue': newValue,
      'wasNote': wasNote,
      'previousNotes': previousNotes,
    };
  }
}
