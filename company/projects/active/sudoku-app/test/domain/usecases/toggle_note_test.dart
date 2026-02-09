/// Unit tests for ToggleNote use case.
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sudoku/domain/entities/entities.dart';
import 'package:sudoku/domain/repositories/game_repository.dart';
import 'package:sudoku/domain/usecases/usecases.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late ToggleNote usecase;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    usecase = ToggleNote(mockRepository);

    registerFallbackValue(
      GameState(
        grid: List<List<Cell>>.generate(
          9,
          (int row) => List<Cell>.generate(
            9,
            (int col) => const Cell(),
          ),
        ),
        difficulty: Difficulty.medium,
      ),
    );
    registerFallbackValue(const Position(row: 0, col: 0));
  });

  final GameState testGameState = GameState(
    grid: List<List<Cell>>.generate(
      9,
      (int row) => List<Cell>.generate(
        9,
        (int col) => const Cell(),
      ),
    ),
    difficulty: Difficulty.medium,
  );

  const Position testPosition = Position(row: 0, col: 0);
  const int testNote = 5;

  test(
    'should toggle note on empty cell',
    () async {
      // Act
      final result = await usecase(
        const ToggleNoteParams(
          gameState: testGameState,
          position: testPosition,
          note: testNote,
        ),
      );

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) {},
        (GameState gameState) {
          expect(
            gameState.cellAt(testPosition.row, testPosition.col).notes,
            contains(testNote),
          );
        },
      );
    },
  );

  test(
    'should return InvalidMoveFailure when cell is given',
    () async {
      // Arrange
      final List<List<Cell>> gridWithGiven =
          List<List<Cell>>.generate(
        9,
        (int row) => List<Cell>.generate(
          9,
          (int col) => row == 0 && col == 0
              ? const Cell(value: 5, isGiven: true)
              : const Cell(),
        ),
      );
      final GameState gameStateWithGiven = testGameState.copyWith(grid: gridWithGiven);

      // Act
      final result = await usecase(
        ToggleNoteParams(
          gameState: gameStateWithGiven,
          position: testPosition,
          note: testNote,
        ),
      );

      // Assert
      expect(result, const Left(InvalidMoveFailure()));
    },
  );

  test(
    'should return InvalidMoveFailure when cell has a value',
    () async {
      // Arrange
      final List<List<Cell>> gridWithValue =
          List<List<Cell>>.generate(
        9,
        (int row) => List<Cell>.generate(
          9,
          (int col) => row == 0 && col == 0
              ? const Cell(value: 5)
              : const Cell(),
        ),
      );
      final GameState gameStateWithValue = testGameState.copyWith(grid: gridWithValue);

      // Act
      final result = await usecase(
        ToggleNoteParams(
          gameState: gameStateWithValue,
          position: testPosition,
          note: testNote,
        ),
      );

      // Assert
      expect(result, const Left(InvalidMoveFailure()));
    },
  );
}
