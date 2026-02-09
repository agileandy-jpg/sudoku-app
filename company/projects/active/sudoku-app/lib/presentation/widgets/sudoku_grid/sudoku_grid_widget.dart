/// Sudoku grid widget.
///
/// Displays the 9x9 Sudoku grid with interactive cells.
library;

import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import 'sudoku_cell_widget.dart';

export 'sudoku_cell_widget.dart';

/// {@template sudoku_grid_widget}
/// Widget that displays the Sudoku grid.
///
/// Renders a 9x9 grid with 3x3 sub-grid separators.
/// Each cell is interactive and responds to tap events.
/// {@endtemplate}
class SudokuGridWidget extends StatelessWidget {
  /// {@macro sudoku_grid_widget}
  const SudokuGridWidget({
    required this.grid,
    required this.selectedPosition,
    required this.onCellTap,
    super.key,
  });

  /// The 9x9 grid of cells to display.
  final List<List<Cell>> grid;

  /// The currently selected cell position, or null if none selected.
  final Position? selectedPosition;

  /// Callback when a cell is tapped.
  final void Function(Position) onCellTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double size = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        // Calculate cell and border sizes
        final double cellSize = size / 9;
        final double thickBorderWidth = 2.0;
        final double thinBorderWidth = 0.5;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: thickBorderWidth,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(9, (int row) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List<Widget>.generate(9, (int col) {
                  final Cell cell = grid[row][col];
                  final bool isSelected =
                      selectedPosition?.row == row &&
                      selectedPosition?.col == col;

                  // Determine border widths
                  final double rightWidth =
                      (col == 2 || col == 5) ? thickBorderWidth : thinBorderWidth;
                  final double bottomWidth =
                      (row == 2 || row == 5) ? thickBorderWidth : thinBorderWidth;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: col == 8 ? 0 : rightWidth,
                        ),
                        bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: row == 8 ? 0 : bottomWidth,
                        ),
                      ),
                    ),
                    child: SudokuCellWidget(
                      cell: cell,
                      size: cellSize,
                      isSelected: isSelected,
                      onTap: () => onCellTap(Position(row: row, col: col)),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
