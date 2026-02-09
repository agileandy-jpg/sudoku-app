/// Widget tests for SudokuCellWidget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/domain/entities/entities.dart';
import 'package:sudoku/presentation/widgets/sudoku_grid/sudoku_cell_widget.dart';

void main() {
  group('SudokuCellWidget', () {
    testWidgets('should display empty cell', (WidgetTester tester) async {
      // Arrange
      const cell = Cell();
      bool tapped = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SudokuCellWidget(
              cell: cell,
              size: 50,
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsNothing);
      expect(find.byType(GestureDetector), findsOneWidget);

      // Test tap
      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('should display cell value', (WidgetTester tester) async {
      // Arrange
      const cell = Cell(value: 5, isGiven: true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SudokuCellWidget(
              cell: cell,
              size: 50,
              isSelected: false,
              onTap: null,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('should display cell notes', (WidgetTester tester) async {
      // Arrange
      const cell = Cell(notes: {1, 3, 5});

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SudokuCellWidget(
              cell: cell,
              size: 50,
              isSelected: false,
              onTap: null,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('2'), findsNothing);
    });

    testWidgets('should highlight when selected', (WidgetTester tester) async {
      // Arrange
      const cell = Cell();

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SudokuCellWidget(
              cell: cell,
              size: 50,
              isSelected: true,
              onTap: null,
            ),
          ),
        ),
      );

      // Assert
      final Container container = tester.widget<Container>(find.byType(Container));
      expect(container.color, isNotNull);
    });
  });
}
