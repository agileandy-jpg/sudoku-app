/// Dependency injection configuration using GetIt.
library;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/game_local_data_source.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/game_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/game_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/check_game_completion.dart';
import '../../domain/usecases/generate_puzzle.dart';
import '../../domain/usecases/get_saved_game.dart';
import '../../domain/usecases/make_move.dart';
import '../../domain/usecases/redo_move.dart';
import '../../domain/usecases/save_game.dart';
import '../../domain/usecases/toggle_note.dart';
import '../../domain/usecases/undo_move.dart';
import '../../presentation/bloc/game/game_bloc.dart';
import '../../presentation/bloc/settings/settings_bloc.dart';

/// Global service locator instance.
/// 
/// Use this instance throughout the application to access
/// registered dependencies.
/// 
/// Example:
/// ```dart
/// final gameRepository = sl<GameRepository>();
/// ```
final GetIt sl = GetIt.instance;

/// {@template init}
/// Initializes the dependency injection container.
/// 
/// This function must be called before the app starts,
/// typically in main() before runApp().
/// 
/// Registers all dependencies in the correct order:
/// 1. External dependencies (SharedPreferences, etc.)
/// 2. Data sources
/// 3. Repositories
/// 4. Use cases
/// 5. BLoCs
/// 
/// Example:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await di.init();
///   runApp(const SudokuApp());
/// }
/// ```
/// {@endtemplate}
Future<void> init() async {
  // External dependencies
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // Data sources
  sl.registerLazySingleton<GameLocalDataSource>(
    () => GameLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerFactory(() => GeneratePuzzle(sl()));
  sl.registerFactory(() => MakeMove(sl()));
  sl.registerFactory(() => UndoMove(sl()));
  sl.registerFactory(() => RedoMove(sl()));
  sl.registerFactory(() => ToggleNote(sl()));
  sl.registerFactory(() => GetSavedGame(sl()));
  sl.registerFactory(() => SaveGame(sl()));
  sl.registerFactory(() => CheckGameCompletion(sl()));

  // BLoCs
  sl.registerFactory(
    () => GameBloc(
      generatePuzzle: sl(),
      makeMove: sl(),
      undoMove: sl(),
      redoMove: sl(),
      toggleNote: sl(),
      getSavedGame: sl(),
      saveGame: sl(),
      checkGameCompletion: sl(),
    ),
  );
  sl.registerFactory(
    () => SettingsBloc(settingsRepository: sl()),
  );
}
