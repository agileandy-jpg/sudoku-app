/**
 * puzzle_generator.dart - Sudoku Puzzle Generator
 * 
 * This file implements a complete Sudoku puzzle generation algorithm.
 * 
 * Algorithm Overview:
 * 1. Generate a complete valid Sudoku solution using backtracking with randomization
 * 2. Create the puzzle by removing cells ("digging") while ensuring unique solution
 * 3. Use constraint-based removal for Easy/Medium (logic-solvable)
 * 4. Use trial-based uniqueness verification for Hard/Expert
 * 
 * Performance target: <500ms for puzzle generation
 */

import 'dart:math';
import '../models/puzzle.dart';

/// Generates Sudoku puzzles with unique solutions and configurable difficulty
class PuzzleGenerator {
  final Random _random;
  
  /// Creates a new puzzle generator with optional random seed
  PuzzleGenerator({int? seed}) : _random = Random(seed);
  
  /// Creates a new puzzle generator with a specific Random instance
  PuzzleGenerator.withRandom(this._random);
  
  /// Generates a new Sudoku puzzle with the specified difficulty
  /// 
  /// [difficulty] - The desired difficulty level (Easy, Medium, Hard, Expert)
  /// 
  /// Returns a [Puzzle] object containing the puzzle grid and solution
  Puzzle generate({Difficulty difficulty = Difficulty.medium}) {
    // Step 1: Generate a complete valid solution grid
    final solution = _generateSolution();
    
    // Step 2: Create puzzle by removing cells while maintaining unique solution
    final puzzleGrid = _createPuzzle(solution, difficulty);
    
    // Step 3: Create and return the Puzzle object
    return Puzzle.fromGrids(
      puzzleGrid: puzzleGrid,
      solutionGrid: solution,
      difficulty: difficulty,
    );
  }
  
  /// Generates a complete valid 9x9 Sudoku solution using randomized backtracking
  List<List<int>> _generateSolution() {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    _fillGrid(grid);
    return grid;
  }
  
  /// Fills the grid with a valid Sudoku solution using backtracking with randomization
  bool _fillGrid(List<List<int>> grid) {
    // Find the next empty cell
    final emptyCell = _findEmptyCell(grid);
    if (emptyCell == null) return true; // Grid is complete
    
    final (row, col) = emptyCell;
    
    // Try numbers 1-9 in random order
    final numbers = _generateShuffledNumbers();
    
    for (final num in numbers) {
      if (_isValidPlacement(grid, row, col, num)) {
        grid[row][col] = num;
        
        if (_fillGrid(grid)) {
          return true;
        }
        
        // Backtrack
        grid[row][col] = 0;
      }
    }
    
    return false;
  }
  
  /// Creates a puzzle by removing cells from the solution while ensuring unique solution
  List<List<int>> _createPuzzle(List<List<int>> solution, Difficulty difficulty) {
    // Start with a copy of the solution
    final puzzle = [
      for (final row in solution) [...row]
    ];
    
    // Calculate how many cells to remove
    final cellsToRemove = 81 - difficulty.givens;
    
    // Get all cell positions and shuffle them
    final positions = _generateShuffledPositions();
    
    // Track how many cells we've removed
    int removed = 0;
    
    for (final (row, col) in positions) {
      if (removed >= cellsToRemove) break;
      
      // Save the current value
      final originalValue = puzzle[row][col];
      
      // Remove the cell
      puzzle[row][col] = 0;
      
      // Check if the puzzle still has a unique solution
      if (_hasUniqueSolution(puzzle, difficulty)) {
        removed++;
      } else {
        // Restore the cell if removing it creates multiple solutions
        puzzle[row][col] = originalValue;
      }
    }
    
    return puzzle;
  }
  
  /// Checks if a puzzle has exactly one unique solution
  /// 
  /// For Easy/Medium: Uses constraint-based solving first (logic only)
  /// For Hard/Expert: Uses backtracking with solution counting (may involve guessing)
  bool _hasUniqueSolution(List<List<int>> puzzle, Difficulty difficulty) {
    // For Easy and Medium, we verify that the puzzle can be solved using
    // logic alone (no guessing required) - this is done by checking if
    // constraint-based solving can complete the puzzle
    if (difficulty == Difficulty.easy || difficulty == Difficulty.medium) {
      // Make a copy for testing
      final testPuzzle = [
        for (final row in puzzle) [...row]
      ];
      
      // Try to solve using constraint propagation (logic only)
      final solved = _solveWithConstraints(testPuzzle);
      
      // If constraint solving completed the puzzle, it has a unique solution
      // and requires no guessing
      return solved;
    }
    
    // For Hard and Expert, we allow puzzles that require advanced techniques
    // or even limited guessing. We verify uniqueness by counting solutions.
    return _countSolutions(puzzle) == 1;
  }
  
  /// Attempts to solve the puzzle using constraint propagation (logic only)
  /// 
  /// This method uses:
  /// 1. Naked singles (only one candidate for a cell)
  /// 2. Hidden singles (only one cell in unit can have a value)
  /// 
  /// Returns true if the puzzle was completely solved
  bool _solveWithConstraints(List<List<int>> grid) {
    final candidates = _computeCandidates(grid);
    
    bool changed = true;
    while (changed) {
      changed = false;
      
      // Look for naked singles
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (grid[row][col] != 0) continue;
          
          final cellCandidates = candidates[row][col];
          if (cellCandidates.length == 1) {
            // Naked single found
            grid[row][col] = cellCandidates.first;
            _updateCandidates(grid, candidates, row, col, cellCandidates.first);
            changed = true;
          }
        }
      }
      
      // Look for hidden singles
      for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
          if (grid[row][col] != 0) continue;
          
          final cellCandidates = candidates[row][col];
          for (final num in cellCandidates) {
            // Check if this number is unique to this cell in row, column, or box
            if (_isHiddenSingle(candidates, row, col, num)) {
              grid[row][col] = num;
              _updateCandidates(grid, candidates, row, col, num);
              changed = true;
              break;
            }
          }
        }
      }
    }
    
    // Check if solved
    for (final row in grid) {
      for (final cell in row) {
        if (cell == 0) return false;
      }
    }
    
    return true;
  }
  
  /// Computes possible candidates for each empty cell
  List<List<Set<int>>> _computeCandidates(List<List<int>> grid) {
    final candidates = List.generate(
      9,
      (_) => List.generate(9, (_) => <int>{}),
    );
    
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) {
          candidates[row][col] = _getValidNumbers(grid, row, col);
        }
      }
    }
    
    return candidates;
  }
  
  /// Gets all valid numbers that can be placed in a cell
  Set<int> _getValidNumbers(List<List<int>> grid, int row, int col) {
    if (grid[row][col] != 0) return <int>{};
    
    final used = <int>{};
    
    // Check row
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] != 0) used.add(grid[row][c]);
    }
    
    // Check column
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] != 0) used.add(grid[r][col]);
    }
    
    // Check 3x3 box
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if (grid[r][c] != 0) used.add(grid[r][c]);
      }
    }
    
    return {1, 2, 3, 4, 5, 6, 7, 8, 9}.difference(used);
  }
  
  /// Updates candidates after placing a number
  void _updateCandidates(
    List<List<int>> grid,
    List<List<Set<int>>> candidates,
    int placedRow,
    int placedCol,
    int placedNum,
  ) {
    // Remove from row
    for (int c = 0; c < 9; c++) {
      candidates[placedRow][c].remove(placedNum);
    }
    
    // Remove from column
    for (int r = 0; r < 9; r++) {
      candidates[r][placedCol].remove(placedNum);
    }
    
    // Remove from box
    final boxRow = (placedRow ~/ 3) * 3;
    final boxCol = (placedCol ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        candidates[r][c].remove(placedNum);
      }
    }
    
    // Clear the placed cell's candidates
    candidates[placedRow][placedCol].clear();
  }
  
  /// Checks if a number is a hidden single for the given cell
  bool _isHiddenSingle(
    List<List<Set<int>>> candidates,
    int row,
    int col,
    int num,
  ) {
    // Check if this number appears only in this cell in the row
    bool uniqueInRow = true;
    for (int c = 0; c < 9; c++) {
      if (c != col && candidates[row][c].contains(num)) {
        uniqueInRow = false;
        break;
      }
    }
    if (uniqueInRow) return true;
    
    // Check if this number appears only in this cell in the column
    bool uniqueInCol = true;
    for (int r = 0; r < 9; r++) {
      if (r != row && candidates[r][col].contains(num)) {
        uniqueInCol = false;
        break;
      }
    }
    if (uniqueInCol) return true;
    
    // Check if this number appears only in this cell in the box
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    bool uniqueInBox = true;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if ((r != row || c != col) && candidates[r][c].contains(num)) {
          uniqueInBox = false;
          break;
        }
      }
      if (!uniqueInBox) break;
    }
    
    return uniqueInBox;
  }
  
  /// Counts the number of solutions for a puzzle (limited to 2 for efficiency)
  /// 
  /// This uses backtracking but stops once 2 solutions are found
  int _countSolutions(List<List<int>> puzzle) {
    // Make a working copy
    final grid = [
      for (final row in puzzle) [...row]
    ];
    
    return _countSolutionsRecursive(grid, 0);
  }
  
  int _countSolutionsRecursive(List<List<int>> grid, int count) {
    if (count >= 2) return count; // Stop at 2 solutions
    
    // Find next empty cell
    final emptyCell = _findEmptyCell(grid);
    if (emptyCell == null) return count + 1; // Found a solution
    
    final (row, col) = emptyCell;
    
    // Try each number 1-9
    for (int num = 1; num <= 9; num++) {
      if (_isValidPlacement(grid, row, col, num)) {
        grid[row][col] = num;
        count = _countSolutionsRecursive(grid, count);
        grid[row][col] = 0; // Backtrack
        
        if (count >= 2) return count; // Early exit
      }
    }
    
    return count;
  }
  
  /// Finds the next empty cell in the grid
  /// Returns (row, col) or null if grid is full
  (int, int)? _findEmptyCell(List<List<int>> grid) {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col] == 0) return (row, col);
      }
    }
    return null;
  }
  
  /// Checks if placing a number at the given position is valid
  bool _isValidPlacement(List<List<int>> grid, int row, int col, int num) {
    // Check row
    for (int c = 0; c < 9; c++) {
      if (grid[row][c] == num) return false;
    }
    
    // Check column
    for (int r = 0; r < 9; r++) {
      if (grid[r][col] == num) return false;
    }
    
    // Check 3x3 box
    final boxRow = (row ~/ 3) * 3;
    final boxCol = (col ~/ 3) * 3;
    for (int r = boxRow; r < boxRow + 3; r++) {
      for (int c = boxCol; c < boxCol + 3; c++) {
        if (grid[r][c] == num) return false;
      }
    }
    
    return true;
  }
  
  /// Generates a shuffled list of numbers 1-9
  List<int> _generateShuffledNumbers() {
    final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    numbers.shuffle(_random);
    return numbers;
  }
  
  /// Generates a shuffled list of all grid positions
  List<(int, int)> _generateShuffledPositions() {
    final positions = <(int, int)>[];
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        positions.add((row, col));
      }
    }
    positions.shuffle(_random);
    return positions;
  }
  
  /// Validates that a completed grid is a valid Sudoku solution
  static bool isValidSolution(List<List<int>> grid) {
    // Check dimensions
    if (grid.length != 9) return false;
    for (final row in grid) {
      if (row.length != 9) return false;
    }
    
    // Check rows
    for (int row = 0; row < 9; row++) {
      final seen = <int>{};
      for (int col = 0; col < 9; col++) {
        final value = grid[row][col];
        if (value < 1 || value > 9) return false;
        if (seen.contains(value)) return false;
        seen.add(value);
      }
    }
    
    // Check columns
    for (int col = 0; col < 9; col++) {
      final seen = <int>{};
      for (int row = 0; row < 9; row++) {
        final value = grid[row][col];
        if (seen.contains(value)) return false;
        seen.add(value);
      }
    }
    
    // Check 3x3 boxes
    for (int boxRow = 0; boxRow < 3; boxRow++) {
      for (int boxCol = 0; boxCol < 3; boxCol++) {
        final seen = <int>{};
        for (int r = boxRow * 3; r < (boxRow + 1) * 3; r++) {
          for (int c = boxCol * 3; c < (boxCol + 1) * 3; c++) {
            final value = grid[r][c];
            if (seen.contains(value)) return false;
            seen.add(value);
          }
        }
      }
    }
    
    return true;
  }
}
