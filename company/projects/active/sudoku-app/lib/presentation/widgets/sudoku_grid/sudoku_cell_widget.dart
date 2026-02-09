/// Sudoku cell widget.
///
/// Displays a single cell in the Sudoku grid.
library;

import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';

/// {@template sudoku_cell_widget}
/// Widget that displays a single Sudoku cell.
///
/// Shows either the cell value, notes, or is empty.
/// Visual state changes based on selection and error status.
/// {@endtemplate}
class SudokuCellWidget extends StatelessWidget {
  /// {@macro sudoku_cell_widget}
  const SudokuCellWidget({
    required this.cell,
    required this.size,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  /// The cell to display.
  final Cell cell;

  /// The size (width and height) of the cell.
  final double size;

  /// Whether this cell is currently selected.
  final bool isSelected;

  /// Callback when the cell is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    // Determine background color
    Color backgroundColor = colorScheme.surface;
    if (isSelected) {
      backgroundColor = colorScheme.primaryContainer;
    } else if (cell.isError) {
      backgroundColor = colorScheme.error.withAlpha(51);
    }

    // Determine text color
    Color textColor = colorScheme.onSurface;
    if (cell.isGiven) {
      textColor = colorScheme.onSurface;
    } else if (cell.isError) {
      textColor = colorScheme.error;
    } else {
      textColor = colorScheme.primary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        color: backgroundColor,
        child: cell.value != null
            ? _buildValueCell(textColor, cell.isGiven)
            : cell.hasNotes
                ? _buildNotesCell(colorScheme)
                : null,
      ),
    );
  }

  /// Builds a cell displaying a value.
  Widget _buildValueCell(Color textColor, bool isBold) {
    return Center(
      child: Text(
        cell.value.toString(),
        style: TextStyle(
          fontSize: size * 0.6,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: textColor,
        ),
      ),
    );
  }

  /// Builds a cell displaying notes.
  Widget _buildNotesCell(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(size * 0.05),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        children: List<Widget>.generate(9, (int index) {
          final int noteValue = index + 1;
          final bool hasNote = cell.notes.contains(noteValue);

          return Center(
            child: hasNote
                ? Text(
                    noteValue.toString(),
                    style: TextStyle(
                      fontSize: size * 0.22,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                : null,
          );
        }),
      ),
    );
  }
}
