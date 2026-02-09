/// Main menu page.
///
/// The entry point of the application.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../bloc/game/game_bloc.dart';
import '../difficulty_selection/difficulty_selection_page.dart';
import '../game/game_page.dart';
import '../settings/settings_page.dart';

/// {@template main_menu_page}
/// The main menu page of the Sudoku app.
///
/// Provides navigation to start a new game, continue a saved game,
/// access settings, or view statistics.
/// {@endtemplate}
class MainMenuPage extends StatelessWidget {
  /// {@macro main_menu_page}
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),

              // App title
              Column(
                children: <Widget>[
                  Icon(
                    Icons.grid_on,
                    size: 80,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sudoku',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Train your brain',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),

              const Spacer(),

              // Menu buttons
              _MenuButton(
                icon: Icons.play_arrow,
                label: 'New Game',
                onPressed: () => _navigateToDifficultySelection(context),
              ),
              const SizedBox(height: 12),
              _MenuButton(
                icon: Icons.restore,
                label: 'Continue Game',
                onPressed: () => _continueGame(context),
              ),
              const SizedBox(height: 12),
              _MenuButton(
                icon: Icons.settings,
                label: 'Settings',
                onPressed: () => _navigateToSettings(context),
              ),

              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDifficultySelection(BuildContext context) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const DifficultySelectionPage(),
      ),
    );
  }

  void _continueGame(BuildContext context) {
    context.read<GameBloc>().add(const SavedGameLoaded());
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const GamePage(),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const SettingsPage(),
      ),
    );
  }
}

/// Menu button widget.
class _MenuButton extends StatelessWidget {
  /// Creates a menu button.
  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
