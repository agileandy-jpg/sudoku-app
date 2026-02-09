/// Test helper with common mocks and utilities.
library;

import 'package:mocktail/mocktail.dart';
import 'package:sudoku/domain/repositories/game_repository.dart';
import 'package:sudoku/domain/repositories/settings_repository.dart';

class MockGameRepository extends Mock implements GameRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

/// Register fallback values for mocktail.
void registerFallbackValues() {
  // Add fallback values as needed
}
