/// Win page.
///
/// Shown when the player completes a puzzle.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../bloc/game/game_bloc.dart';
import '../difficulty_selection/difficulty_selection_page.dart';
import '../main_menu/main_menu_page.dart';

/// {@template win_page}
/// Page displayed when the player successfully completes a puzzle.
///
/// Shows the final score, time taken, and options to play again
/// or return to the main menu.
/// {@endtemplate}
class WinPage extends StatelessWidget {
  /// {@macro win_page}
  const WinPage({
    required this.score,
    required this.elapsedTime,
    required this.difficulty,
    super.key,
  });

  /// The final score achieved.
  final int score;

  /// The time taken to complete the puzzle.
  final Duration elapsedTime;

  /// The difficulty level of the completed puzzle.
  final Difficulty difficulty;

  /// Formats a duration into HH:MM:SS or MM:SS string.
  String _formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

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

              // Success icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 64,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),

              // Congratulations text
              Text(
                'Puzzle Complete!',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Great job solving the ${difficulty.label} puzzle',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Stats cards
              Row(
                children: <Widget>[
                  Expanded(
                    child: _StatCard(
                      icon: Icons.timer,
                      label: 'Time',
                      value: _formatDuration(elapsedTime),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.star,
                      label: 'Score',
                      value: score.toString(),
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Action buttons
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _playAgain(context),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text(
                    'Play Again',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () => _returnToMenu(context),
                  icon: const Icon(Icons.home),
                  label: const Text(
                    'Main Menu',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _playAgain(BuildContext context) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const DifficultySelectionPage(),
      ),
    );
  }

  void _returnToMenu(BuildContext context) {
    Navigator.pushAndRemoveUntil<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const MainMenuPage(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}

/// Stat card widget.
class _StatCard extends StatelessWidget {
  /// Creates a stat card.
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
