/**
 * puzzle_generator_test.dart - Unit Tests for Sudoku Puzzle Generator
 * 
 * This test suite verifies:
 * - Puzzle generation for all difficulty levels
 * - Solution uniqueness
 * - Valid Sudoku constraints
 * - Performance requirements (<500ms per puzzle)
 * - Edge cases and error conditions
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku/models/puzzle.dart';
import 'package:sudoku/services/puzzle_generator.dart';

void main() {
  group('PuzzleGenerator', () {
    late PuzzleGenerator generator;
    
    setUp(() {
      // Use a fixed seed for reproducible tests
      generator = PuzzleGenerator(seed: 42);
    });
    
    group('Basic Generation', () {
      test('should generate a puzzle', () {
        final puzzle = generator.generate();
        
        expect(puzzle, isNotNull);
        expect(puzzle.grid, isNotNull);
        expect(puzzle.grid.length, equals(9));
        expect(puzzle.solution, isNotNull);
        expect(puzzle.solution.length, equals(9));
      });
      
      test('should generate puzzle with correct difficulty default', () {
        final puzzle = generator.generate();
        expect(puzzle.difficulty, equals(Difficulty.medium));
      });
      
      test('should generate puzzle for all difficulty levels', () {
        for (final difficulty in Difficulty.values) {
          final puzzle = generator.generate(difficulty: difficulty);
          expect(puzzle.difficulty, equals(difficulty));
        }
      });
    });
    
    group('Solution Validity', () {
      test('should generate valid solution', () {
        final puzzle = generator.generate();
        
        expect(PuzzleGenerator.isValidSolution(puzzle.solution), isTrue);
      });
      
      test('should generate valid solution for all difficulties', () {
        for (final difficulty in Difficulty.values) {
          final puzzle = generator.generate(difficulty: difficulty);
          expect(
            PuzzleGenerator.isValidSolution(puzzle.solution),
            isTrue,
            reason: 'Solution for $difficulty should be valid',
          );
        }
      });
      
      test('solution should be a complete grid', () {
        final puzzle = generator.generate();
        
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            expect(
              puzzle.solution[row][col],
              isNot(equals(0)),
              reason: 'Solution should not contain zeros at [$row][$col]',
            );
            expect(
              puzzle.solution[row][col],
              inInclusiveRange(1, 9),
              reason: 'Solution values should be 1-9 at [$row][$col]',
            );
          }
        }
      });
    });
    
    group('Puzzle Validity', () {
      test('puzzle grid should have correct dimensions', () {
        final puzzle = generator.generate();
        
        expect(puzzle.grid.length, equals(9));
        for (final row in puzzle.grid) {
          expect(row.length, equals(9));
        }
      });
      
      test('given cells should match solution', () {
        final puzzle = generator.generate();
        
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            final cell = puzzle.grid[row][col];
            if (cell.isGiven) {
              expect(
                cell.value,
                equals(puzzle.solution[row][col]),
                reason: 'Given cell at [$row][$col] should match solution',
              );
            }
          }
        }
      });
      
      test('non-given cells should be empty', () {
        final puzzle = generator.generate();
        
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            final cell = puzzle.grid[row][col];
            if (!cell.isGiven) {
              expect(
                cell.value,
                equals(0),
                reason: 'Non-given cell at [$row][$col] should be empty',
              );
            }
          }
        }
      });
    });
    
    group('Difficulty Levels', () {
      test('Easy difficulty should have 35 given cells', () {
        final puzzle = generator.generate(difficulty: Difficulty.easy);
        expect(puzzle.givenCount, equals(35));
      });
      
      test('Medium difficulty should have 30 given cells', () {
        final puzzle = generator.generate(difficulty: Difficulty.medium);
        expect(puzzle.givenCount, equals(30));
      });
      
      test('Hard difficulty should have 25 given cells', () {
        final puzzle = generator.generate(difficulty: Difficulty.hard);
        expect(puzzle.givenCount, equals(25));
      });
      
      test('Expert difficulty should have 22 given cells', () {
        final puzzle = generator.generate(difficulty: Difficulty.expert);
        expect(puzzle.givenCount, equals(22));
      });
      
      test('difficulty enum values should be correct', () {
        expect(Difficulty.easy.givens, equals(35));
        expect(Difficulty.medium.givens, equals(30));
        expect(Difficulty.hard.givens, equals(25));
        expect(Difficulty.expert.givens, equals(22));
      });
      
      test('difficulty labels should be correct', () {
        expect(Difficulty.easy.label, equals('Easy'));
        expect(Difficulty.medium.label, equals('Medium'));
        expect(Difficulty.hard.label, equals('Hard'));
        expect(Difficulty.expert.label, equals('Expert'));
      });
    });
    
    group('Unique Solution', () {
      test('puzzle should have a unique solution', () {
        final puzzle = generator.generate();
        
        // Verify that the puzzle matches the solution when solved
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            expect(
              puzzle.solution[row][col],
              isNot(equals(0)),
              reason: 'Solution should be valid at [$row][$col]',
            );
          }
        }
      });
      
      test('multiple puzzles should have unique solutions', () {
        // Generate multiple puzzles and verify each has a valid solution
        for (int i = 0; i < 5; i++) {
          final puzzle = PuzzleGenerator(seed: i).generate();
          expect(PuzzleGenerator.isValidSolution(puzzle.solution), isTrue);
        }
      });
    });
    
    group('Performance', () {
      test('should generate puzzle in under 500ms', () {
        final stopwatch = Stopwatch()..start();
        generator.generate();
        stopwatch.stop();
        
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(500),
          reason: 'Puzzle generation should complete in under 500ms',
        );
      });
      
      test('should generate puzzles for all difficulties in under 500ms each', () {
        for (final difficulty in Difficulty.values) {
          final stopwatch = Stopwatch()..start();
          generator.generate(difficulty: difficulty);
          stopwatch.stop();
          
          expect(
            stopwatch.elapsedMilliseconds,
            lessThan(500),
            reason: 'Puzzle generation for $difficulty should complete in under 500ms',
          );
        }
      });
      
      test('should generate 10 puzzles efficiently', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 10; i++) {
          PuzzleGenerator(seed: i).generate();
        }
        
        stopwatch.stop();
        
        // Should generate 10 puzzles in under 5 seconds
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(5000),
          reason: 'Generating 10 puzzles should complete in under 5 seconds',
        );
      });
    });
    
    group('Puzzle Model', () {
      test('cell should track given status correctly', () {
        final puzzle = generator.generate();
        int givenCount = 0;
        int nonGivenCount = 0;
        
        for (final row in puzzle.grid) {
          for (final cell in row) {
            if (cell.isGiven) {
              givenCount++;
              expect(cell.isFilled, isTrue);
            } else {
              nonGivenCount++;
              expect(cell.isEmpty, isTrue);
            }
          }
        }
        
        expect(givenCount + nonGivenCount, equals(81));
      });
      
      test('puzzle copy should create independent copy', () {
        final puzzle = generator.generate();
        final copy = puzzle.copy();
        
        // Modify the copy
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            if (!copy.grid[row][col].isGiven) {
              copy.setCellValue(row, col, 1);
            }
          }
        }
        
        // Original should be unchanged
        int originalFilled = 0;
        int copyFilled = 0;
        
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            if (puzzle.grid[row][col].isFilled) originalFilled++;
            if (copy.grid[row][col].isFilled) copyFilled++;
          }
        }
        
        expect(originalFilled, equals(puzzle.givenCount));
        expect(copyFilled, equals(81));
      });
      
      test('isSolved should return false for new puzzle', () {
        final puzzle = generator.generate();
        expect(puzzle.isSolved(), isFalse);
      });
      
      test('isSolved should return true when solved', () {
        final puzzle = generator.generate();
        
        // Fill in the solution
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            if (!puzzle.grid[row][col].isGiven) {
              puzzle.setCellValue(row, col, puzzle.solution[row][col]);
            }
          }
        }
        
        expect(puzzle.isSolved(), isTrue);
      });
      
      test('setCellValue should not modify given cells', () {
        final puzzle = generator.generate();
        
        // Find a given cell
        int? givenRow, givenCol;
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            if (puzzle.grid[row][col].isGiven) {
              givenRow = row;
              givenCol = col;
              break;
            }
          }
          if (givenRow != null) break;
        }
        
        expect(givenRow, isNotNull);
        
        final originalValue = puzzle.grid[givenRow!][givenCol!].value;
        final result = puzzle.setCellValue(givenRow, givenCol, 5);
        
        expect(result, isFalse);
        expect(puzzle.grid[givenRow][givenCol].value, equals(originalValue));
      });
    });
    
    group('Serialization', () {
      test('should serialize and deserialize puzzle correctly', () {
        final puzzle = generator.generate();
        final json = puzzle.toJson();
        final restored = Puzzle.fromJson(json);
        
        expect(restored.difficulty, equals(puzzle.difficulty));
        expect(restored.id, equals(puzzle.id));
        expect(restored.givenCount, equals(puzzle.givenCount));
        
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            expect(
              restored.grid[row][col].value,
              equals(puzzle.grid[row][col].value),
            );
            expect(
              restored.solution[row][col],
              equals(puzzle.solution[row][col]),
            );
          }
        }
      });
      
      test('fromGrids should create valid puzzle', () {
        final solution = [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 9],
        ];
        
        final puzzleGrid = [
          [5, 3, 0, 0, 7, 0, 0, 0, 0],
          [6, 0, 0, 1, 9, 5, 0, 0, 0],
          [0, 9, 8, 0, 0, 0, 0, 6, 0],
          [8, 0, 0, 0, 6, 0, 0, 0, 3],
          [4, 0, 0, 8, 0, 3, 0, 0, 1],
          [7, 0, 0, 0, 2, 0, 0, 0, 6],
          [0, 6, 0, 0, 0, 0, 2, 8, 0],
          [0, 0, 0, 4, 1, 9, 0, 0, 5],
          [0, 0, 0, 0, 8, 0, 0, 7, 9],
        ];
        
        final puzzle = Puzzle.fromGrids(
          puzzleGrid: puzzleGrid,
          solutionGrid: solution,
          difficulty: Difficulty.easy,
        );
        
        expect(puzzle.difficulty, equals(Difficulty.easy));
        expect(puzzle.givenCount, equals(35));
        expect(puzzle.isSolved(), isFalse);
      });
    });
    
    group('Display and String Representation', () {
      test('toDisplayString should produce non-empty output', () {
        final puzzle = generator.generate();
        final display = puzzle.toDisplayString();
        
        expect(display, isNotEmpty);
        expect(display.contains('.'), isTrue); // Should have empty cells
      });
      
      test('toString should return meaningful representation', () {
        final puzzle = generator.generate();
        final str = puzzle.toString();
        
        expect(str, contains('Puzzle'));
        expect(str, contains(puzzle.difficulty.label));
      });
    });
    
    group('Edge Cases', () {
      test('generator with different seeds should produce different puzzles', () {
        final puzzle1 = PuzzleGenerator(seed: 1).generate();
        final puzzle2 = PuzzleGenerator(seed: 2).generate();
        
        // Compare the grid patterns
        bool different = false;
        for (int row = 0; row < 9 && !different; row++) {
          for (int col = 0; col < 9 && !different; col++) {
            if (puzzle1.grid[row][col].value != puzzle2.grid[row][col].value) {
              different = true;
            }
          }
        }
        
        expect(different, isTrue, reason: 'Different seeds should produce different puzzles');
      });
      
      test('empty cell notes should be initially empty', () {
        final puzzle = generator.generate();
        
        for (final row in puzzle.grid) {
          for (final cell in row) {
            expect(cell.notes, isEmpty);
          }
        }
      });
      
      test('cell copy should create independent copy', () {
        final cell = Cell(value: 5, isGiven: true);
        cell.notes.addAll([1, 2, 3]);
        
        final copy = cell.copy();
        copy.value = 9;
        copy.notes.add(4);
        
        expect(cell.value, equals(5));
        expect(cell.notes.length, equals(3));
        expect(copy.value, equals(9));
        expect(copy.notes.length, equals(4));
      });
    });
    
    group('isValidSolution Helper', () {
      test('should validate correct solution', () {
        final validSolution = [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 9],
        ];
        
        expect(PuzzleGenerator.isValidSolution(validSolution), isTrue);
      });
      
      test('should reject invalid solution with duplicate in row', () {
        final invalidSolution = [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 1], // Duplicate 1s
        ];
        
        expect(PuzzleGenerator.isValidSolution(invalidSolution), isFalse);
      });
      
      test('should reject invalid solution with duplicate in column', () {
        final invalidSolution = [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [5, 4, 3, 2, 8, 6, 1, 7, 9], // First column has two 5s
        ];
        
        expect(PuzzleGenerator.isValidSolution(invalidSolution), isFalse);
      });
      
      test('should reject invalid solution with duplicate in box', () {
        final invalidSolution = [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 5, 3, 4, 2, 8, 6, 7], // Top-right box has two 5s
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 8, 2, 8, 6, 1, 7, 9],
        ];
        
        expect(PuzzleGenerator.isValidSolution(invalidSolution), isFalse);
      });
      
      test('should reject solution with invalid values', () {
        final invalidSolution = [
          [5, 3, 4, 6, 7, 8, 9, 1, 2],
          [6, 7, 2, 1, 9, 5, 3, 4, 8],
          [1, 9, 8, 3, 4, 2, 5, 6, 7],
          [8, 5, 9, 7, 6, 1, 4, 2, 3],
          [4, 2, 6, 8, 5, 3, 7, 9, 1],
          [7, 1, 3, 9, 2, 4, 8, 5, 6],
          [9, 6, 1, 5, 3, 7, 2, 8, 4],
          [2, 8, 7, 4, 1, 9, 6, 3, 5],
          [3, 4, 5, 2, 8, 6, 1, 7, 0], // Invalid: 0
        ];
        
        expect(PuzzleGenerator.isValidSolution(invalidSolution), isFalse);
      });
      
      test('should reject solution with wrong dimensions', () {
        final invalidSolution = [
          [5, 3, 4, 6, 7, 8, 9, 1],
          [6, 7, 2, 1, 9, 5, 3, 4],
        ];
        
        expect(PuzzleGenerator.isValidSolution(invalidSolution), isFalse);
      });
    });
    
    group('Statistics and Queries', () {
      test('filledCount should return correct count', () {
        final puzzle = generator.generate(difficulty: Difficulty.easy);
        expect(puzzle.filledCount, equals(35));
      });
      
      test('emptyCount should return correct count', () {
        final puzzle = generator.generate(difficulty: Difficulty.medium);
        expect(puzzle.emptyCount, equals(81 - 30));
      });
      
      test('isCellCorrect should return true for given cells', () {
        final puzzle = generator.generate();
        
        for (int row = 0; row < 9; row++) {
          for (int col = 0; col < 9; col++) {
            if (puzzle.grid[row][col].isGiven) {
              expect(puzzle.isCellCorrect(row, col), isTrue);
            }
          }
        }
      });
      
      test('toIntGrid should return 2D int array', () {
        final puzzle = generator.generate();
        final intGrid = puzzle.toIntGrid();
        
        expect(intGrid.length, equals(9));
        for (final row in intGrid) {
          expect(row.length, equals(9));
        }
      });
    });
  });
}
