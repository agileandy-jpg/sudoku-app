/**
 * puzzle.dart - Sudoku Puzzle Data Model
 * 
 * This file defines the core data structures for representing Sudoku puzzles,
 * including the puzzle state, solution, difficulty level, and serialization support.
 */

/// Represents the difficulty levels available for Sudoku puzzles.
/// Each level has a specific number of pre-filled cells (givens).
enum Difficulty {
  /// Easy difficulty with 35 given cells
  easy(givens: 35, label: 'Easy'),
  
  /// Medium difficulty with 30 given cells
  medium(givens: 30, label: 'Medium'),
  
  /// Hard difficulty with 25 given cells
  hard(givens: 25, label: 'Hard'),
  
  /// Expert difficulty with 22 given cells
  expert(givens: 22, label: 'Expert');
  
  /// The number of cells that should be pre-filled for this difficulty
  final int givens;
  
  /// Human-readable label for the difficulty
  final String label;
  
  const Difficulty({required this.givens, required this.label});
}

/// Represents the state of a single cell in the Sudoku grid.
/// Cells can either contain a fixed given value or a user-entered value.
class Cell {
  /// The current value (0 = empty, 1-9 = filled)
  int value;
  
  /// Whether this cell is a given (pre-filled) value
  final bool isGiven;
  
  /// User notes (candidates) for this cell - used in the UI
  Set<int> notes;
  
  /// Creates a new cell with the specified value and given status
  Cell({this.value = 0, this.isGiven = false}) : notes = <int>{};
  
  /// Creates a copy of this cell
  Cell copy() {
    final newCell = Cell(value: value, isGiven: isGiven);
    newCell.notes = Set<int>.from(notes);
    return newCell;
  }
  
  /// Returns true if the cell is empty (value = 0)
  bool get isEmpty => value == 0;
  
  /// Returns true if the cell is filled (value 1-9)
  bool get isFilled => value != 0;
  
  @override
  String toString() => value.toString();
}

/// Represents a complete Sudoku puzzle with its state and solution.
class Puzzle {
  /// The 9x9 grid of cells
  final List<List<Cell>> grid;
  
  /// The solution grid (stored for validation and hint generation)
  final List<List<int>> solution;
  
  /// The difficulty level of this puzzle
  final Difficulty difficulty;
  
  /// Timestamp when the puzzle was generated
  final DateTime createdAt;
  
  /// Puzzle ID for persistence
  final String id;
  
  /// Creates a new puzzle with the specified grid and solution
  Puzzle({
    required this.grid,
    required this.solution,
    required this.difficulty,
    String? id,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();
  
  /// Creates a deep copy of this puzzle
  Puzzle copy() {
    return Puzzle(
      grid: [
        for (final row in grid)
          [for (final cell in row) cell.copy()]
      ],
      solution: [
        for (final row in solution) [...row]
      ],
      difficulty: difficulty,
      id: id,
      createdAt: createdAt,
    );
  }
  
  /// Gets a cell at the specified row and column (0-indexed)
  Cell getCell(int row, int col) => grid[row][col];
  
  /// Sets the value of a cell at the specified position
  /// Returns false if trying to modify a given cell
  bool setCellValue(int row, int col, int value) {
    if (grid[row][col].isGiven) return false;
    grid[row][col].value = value;
    return true;
  }
  
  /// Gets the solution value at the specified position
  int getSolutionValue(int row, int col) => solution[row][col];
  
  /// Returns the correct value for a cell (used for hints)
  int getCorrectValue(int row, int col) => solution[row][col];
  
  /// Checks if the puzzle is completely solved correctly
  bool isSolved() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (grid[row][col].value != solution[row][col]) {
          return false;
        }
      }
    }
    return true;
  }
  
  /// Checks if a specific cell has the correct value
  bool isCellCorrect(int row, int col) {
    return grid[row][col].value == solution[row][col];
  }
  
  /// Gets the number of filled cells (non-empty)
  int get filledCount {
    int count = 0;
    for (final row in grid) {
      for (final cell in row) {
        if (cell.isFilled) count++;
      }
    }
    return count;
  }
  
  /// Gets the number of empty cells
  int get emptyCount => 81 - filledCount;
  
  /// Gets the number of given cells
  int get givenCount {
    int count = 0;
    for (final row in grid) {
      for (final cell in row) {
        if (cell.isGiven) count++;
      }
    }
    return count;
  }
  
  /// Converts the puzzle to a 2D integer array (0 for empty cells)
  List<List<int>> toIntGrid() {
    return [
      for (final row in grid)
        [for (final cell in row) cell.value]
    ];
  }
  
  /// Creates a puzzle from integer grids
  static Puzzle fromGrids({
    required List<List<int>> puzzleGrid,
    required List<List<int>> solutionGrid,
    required Difficulty difficulty,
  }) {
    final cells = <List<Cell>>[];
    for (int row = 0; row < 9; row++) {
      final rowCells = <Cell>[];
      for (int col = 0; col < 9; col++) {
        final value = puzzleGrid[row][col];
        rowCells.add(Cell(value: value, isGiven: value != 0));
      }
      cells.add(rowCells);
    }
    
    return Puzzle(
      grid: cells,
      solution: solutionGrid,
      difficulty: difficulty,
    );
  }
  
  /// Serializes the puzzle to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'difficulty': difficulty.name,
      'createdAt': createdAt.toIso8601String(),
      'grid': toIntGrid(),
      'solution': solution,
    };
  }
  
  /// Deserializes a puzzle from a JSON map
  static Puzzle fromJson(Map<String, dynamic> json) {
    final difficulty = Difficulty.values.firstWhere(
      (d) => d.name == json['difficulty'],
      orElse: () => Difficulty.medium,
    );
    
    final gridData = (json['grid'] as List).cast<List<dynamic>>();
    final solutionData = (json['solution'] as List).cast<List<dynamic>>();
    
    final puzzleGrid = gridData
        .map((row) => (row as List).cast<int>().toList())
        .toList();
    final solutionGrid = solutionData
        .map((row) => (row as List).cast<int>().toList())
        .toList();
    
    return Puzzle.fromGrids(
      puzzleGrid: puzzleGrid,
      solutionGrid: solutionGrid,
      difficulty: difficulty,
    );
  }
  
  /// Returns a string representation of the puzzle grid
  String toDisplayString() {
    final buffer = StringBuffer();
    for (int row = 0; row < 9; row++) {
      if (row % 3 == 0 && row > 0) {
        buffer.writeln('------+-------+------');
      }
      for (int col = 0; col < 9; col++) {
        if (col % 3 == 0 && col > 0) {
          buffer.write('| ');
        }
        final value = grid[row][col].value;
        buffer.write(value == 0 ? '. ' : '$value ');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
  
  @override
  String toString() => 'Puzzle(id: $id, difficulty: ${difficulty.label}, givens: $givenCount)';
}
