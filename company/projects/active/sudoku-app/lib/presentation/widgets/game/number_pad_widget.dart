/// Number pad widget.
///
/// Displays a numeric keypad for entering values.
library;

import 'package:flutter/material.dart';

/// {@template number_pad_widget}
/// Widget that displays a numeric keypad (1-9).
///
/// Used for entering values into Sudoku cells.
/// {@endtemplate}
class NumberPadWidget extends StatelessWidget {
  /// {@macro number_pad_widget}
  const NumberPadWidget({
    required this.onNumberPressed,
    this.highlightedNumber,
    super.key,
  });

  /// Callback when a number is pressed.
  final void Function(int) onNumberPressed;

  /// A number to highlight (if already present in the grid).
  final int? highlightedNumber;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List<Widget>.generate(9, (int index) {
        final int number = index + 1;
        final bool isHighlighted = highlightedNumber == number;

        return SizedBox(
          width: 56,
          height: 56,
          child: ElevatedButton(
            onPressed: () => onNumberPressed(number),
            style: ElevatedButton.styleFrom(
              backgroundColor: isHighlighted
                  ? colorScheme.primaryContainer
                  : colorScheme.surface,
              foregroundColor: isHighlighted
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurface,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: colorScheme.outline,
                ),
              ),
              elevation: isHighlighted ? 2 : 1,
            ),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}
