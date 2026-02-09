/// Widget tests for TimerWidget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/presentation/widgets/game/timer_widget.dart';

void main() {
  group('TimerWidget', () {
    testWidgets('should display formatted time', (WidgetTester tester) async {
      // Arrange
      const elapsedSeconds = 125; // 2:05

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerWidget(elapsedSeconds: elapsedSeconds),
          ),
        ),
      );

      // Assert
      expect(find.text('02:05'), findsOneWidget);
    });

    testWidgets('should display zero time correctly', (WidgetTester tester) async {
      // Arrange
      const elapsedSeconds = 0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerWidget(elapsedSeconds: elapsedSeconds),
          ),
        ),
      );

      // Assert
      expect(find.text('00:00'), findsOneWidget);
    });

    testWidgets('should display timer icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerWidget(elapsedSeconds: 0),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.timer), findsOneWidget);
    });
  });
}
