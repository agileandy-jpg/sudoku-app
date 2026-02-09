/// Unit tests for MakeMove use case.
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sudoku/domain/entities/entities.dart';
import 'package:sudoku/domain/repositories/game_repository.dart';
import 'package:sudoku/domain/usecases/usecases.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late MakeMove usecase;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    usecase = MakeMove(mockRepository);

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
  const int testValue = 5;

  test(
    'should return updated GameState when move is valid',
    () async {
      // Arrange
      when(() => mockRepository.validateMove(any(), any(), any()))
          .thenReturn(const Right(true));
      when(() => mockRepository.checkCompletion(any()))
          .thenReturn(const Right(false));

      // Act
      final result = await usecase(
        const MakeMoveParams(
          gameState: testGameState,
          position: testPosition,
          value: testValue,
        ),
      );

      // Assert
      expect(result.isRight(), true);
    },
  );

  test(
    'should return InvalidMoveFailure when move is invalid',
    () async {
      // Arrange
      when(() => mockRepository.validateMove(any(), any(), any()))
          .thenReturn(const Left(InvalidMoveFailure()));

      // Act
      final result = await usecase(
        const MakeMoveParams(
          gameState: testGameState,
          position: testPosition,
          value: testValue,
        ),
      );

      // Assert
      expect(result, const Left(InvalidMoveFailure()));
    },
  );
}
