/// Unit tests for GeneratePuzzle use case.
library;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sudoku/domain/entities/entities.dart';
import 'package:sudoku/domain/repositories/game_repository.dart';
import 'package:sudoku/domain/usecases/usecases.dart';

class MockGameRepository extends Mock implements GameRepository {}

void main() {
  late GeneratePuzzle usecase;
  late MockGameRepository mockRepository;

  setUp(() {
    mockRepository = MockGameRepository();
    usecase = GeneratePuzzle(mockRepository);
  });

  const Difficulty testDifficulty = Difficulty.medium;

  test(
    'should return GameState when repository generates puzzle successfully',
    () async {
      // Arrange
      final GameState expectedGame = GameState(
        grid: List<List<Cell>>.generate(
          9,
          (int row) => List<Cell>.generate(
            9,
            (int col) => const Cell(),
          ),
        ),
        difficulty: testDifficulty,
      );

      when(() => mockRepository.generatePuzzle(testDifficulty))
          .thenAnswer((_) async => Right(expectedGame));

      // Act
      final result = await usecase(testDifficulty);

      // Assert
      expect(result, Right(expectedGame));
      verify(() => mockRepository.generatePuzzle(testDifficulty)).called(1);
    },
  );

  test(
    'should return Failure when puzzle generation fails',
    () async {
      // Arrange
      when(() => mockRepository.generatePuzzle(testDifficulty))
          .thenAnswer((_) async => const Left(PuzzleGenerationFailure()));

      // Act
      final result = await usecase(testDifficulty);

      // Assert
      expect(result.isLeft(), true);
      verify(() => mockRepository.generatePuzzle(testDifficulty)).called(1);
    },
  );
}
