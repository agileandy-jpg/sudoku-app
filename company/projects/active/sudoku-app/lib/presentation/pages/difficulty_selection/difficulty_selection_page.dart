/// Difficulty selection page.
///
/// Allows the user to select game difficulty.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../bloc/game/game_bloc.dart';
import '../game/game_page.dart';

/// {@template difficulty_selection_page}
/// Page for selecting the game difficulty.
///
/// Displays all available difficulty levels with descriptions
/// and estimated solve times.
/// {@endtemplate}
class DifficultySelectionPage extends StatelessWidget {
  /// {@macro difficulty_selection_page}
  const DifficultySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Difficulty'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Choose your challenge',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: Difficulty.values.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final Difficulty difficulty = Difficulty.values[index];
                    return _DifficultyCard(
                      difficulty: difficulty,
                      onTap: () => _startGame(context, difficulty),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, Difficulty difficulty) {
    context.read<GameBloc>().add(NewGameStarted(difficulty: difficulty));
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => const GamePage(),
      ),
    );
  }
}

/// Difficulty selection card.
class _DifficultyCard extends StatelessWidget {
  /// Creates a difficulty card.
  const _DifficultyCard({
    required this.difficulty,
    required this.onTap,
  });

  final Difficulty difficulty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    String description;
    Color accentColor;

    switch (difficulty) {
      case Difficulty.easy:
        description = 'Great for beginners. Plenty of given numbers.';
        accentColor = Colors.green;
      case Difficulty.medium:
        description = 'A balanced challenge for casual players.';
        accentColor = Colors.blue;
      case Difficulty.hard:
        description = 'For experienced players who like a challenge.';
        accentColor = Colors.orange;
      case Difficulty.expert:
        description = 'Maximum difficulty. For Sudoku masters.';
        accentColor = Colors.red;
    }

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.signal_cellular_alt,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      difficulty.label,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${difficulty.givenCells} given numbers • ${difficulty.estimatedTime}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
