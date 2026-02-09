/// Cell model for JSON serialization.
///
/// Represents a single cell in the Sudoku grid for data transfer.
library;

import '../../domain/entities/entities.dart';

/// {@template cell_model}
/// Model class for serializing and deserializing [Cell] entities.
///
/// Converts between [Cell] domain entities and JSON-compatible maps.
/// {@endtemplate}
class CellModel {
  /// {@macro cell_model}
  const CellModel({
    this.value,
    required this.isGiven,
    required this.notes,
    required this.isError,
  });

  /// Creates a [CellModel] from a domain [Cell] entity.
  ///
  /// [cell] The domain entity to convert.
  factory CellModel.fromEntity(Cell cell) {
    return CellModel(
      value: cell.value,
      isGiven: cell.isGiven,
      notes: cell.notes.toList(),
      isError: cell.isError,
    );
  }

  /// Creates a [CellModel] from a JSON map.
  ///
  /// [json] The JSON map to deserialize.
  factory CellModel.fromJson(Map<String, dynamic> json) {
    return CellModel(
      value: json['value'] as int?,
      isGiven: json['isGiven'] as bool? ?? false,
      notes: (json['notes'] as List<dynamic>?)
              ?.map((dynamic e) => e as int)
              .toList() ??
          <int>[],
      isError: json['isError'] as bool? ?? false,
    );
  }

  /// The numeric value of the cell (1-9), or null if empty.
  final int? value;

  /// True if this cell is part of the original puzzle.
  final bool isGiven;

  /// List of pencil marks/notes for this cell.
  final List<int> notes;

  /// True if this cell conflicts with Sudoku rules.
  final bool isError;

  /// Converts this model to a domain [Cell] entity.
  Cell toEntity() {
    return Cell(
      value: value,
      isGiven: isGiven,
      notes: notes.toSet(),
      isError: isError,
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'value': value,
      'isGiven': isGiven,
      'notes': notes,
      'isError': isError,
    };
  }
}
