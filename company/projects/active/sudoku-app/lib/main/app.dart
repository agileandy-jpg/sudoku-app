/// Sudoku app widget.
///
/// Root widget of the application with routing and theming.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../core/theme/app_theme.dart';
import '../domain/entities/entities.dart';
import '../presentation/bloc/game/game_bloc.dart';
import '../presentation/bloc/settings/settings_bloc.dart';
import '../presentation/pages/main_menu/main_menu_page.dart';

/// {@template sudoku_app}
/// Root widget of the Sudoku application.
///
/// Provides global BLoC providers, theming, and navigation.
/// {@endtemplate}
class SudokuApp extends StatelessWidget {
  /// {@macro sudoku_app}
  const SudokuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<SettingsBloc>(
          create: (BuildContext context) => sl<SettingsBloc>(),
        ),
        BlocProvider<GameBloc>(
          create: (BuildContext context) => sl<GameBloc>()..add(const GameInitialized()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (SettingsState previous, SettingsState current) {
          return current is SettingsLoadedState;
        },
        builder: (BuildContext context, SettingsState state) {
          ThemeMode themeMode = ThemeMode.system;

          if (state is SettingsLoadedState) {
            themeMode = _mapThemeMode(state.settings.themeMode);
          }

          return MaterialApp(
            title: 'Sudoku',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: const MainMenuPage(),
          );
        },
      ),
    );
  }

  /// Maps domain ThemeMode to Flutter ThemeMode.
  ThemeMode _mapThemeMode(domain.ThemeMode mode) {
    switch (mode) {
      case domain.ThemeMode.light:
        return ThemeMode.light;
      case domain.ThemeMode.dark:
        return ThemeMode.dark;
      case domain.ThemeMode.system:
        return ThemeMode.system;
    }
  }
}
