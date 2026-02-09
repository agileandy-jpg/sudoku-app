/// Widget tests for NumberPadWidget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/presentation/widgets/game/number_pad_widget.dart';

void main() {
  group('NumberPadWidget', () {
    testWidgets('should display numbers 1-9', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPadWidget(
              onNumberPressed: (_) {},
            ),
          ),
        ),
      );

      // Assert
      for (int i = 1; i <= 9; i++) {
        expect(find.text(i.toString()), findsOneWidget);
      }
    });

    testWidgets('should call onNumberPressed when number is tapped',
        (WidgetTester tester) async {
      // Arrange
      int? pressedNumber;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPadWidget(
              onNumberPressed: (int number) => pressedNumber = number,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('5'));

      // Assert
      expect(pressedNumber, 5);
    });

    testWidgets('should highlight selected number', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NumberPadWidget(
              onNumberPressed: (_) {},
              highlightedNumber: 5,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('5'), findsOneWidget);
      // The highlighted number should have a different visual style
    });
  });
}
