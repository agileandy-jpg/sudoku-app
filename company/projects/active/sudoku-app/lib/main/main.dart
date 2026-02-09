/// Main entry point for the Sudoku application.
///
/// Initializes dependencies and runs the app.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/di/injection.dart' as di;
import 'main/app.dart';

/// Application entry point.
///
/// Initializes Flutter bindings, sets preferred orientations,
/// initializes dependency injection, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection
  await di.init();

  runApp(const SudokuApp());
}
