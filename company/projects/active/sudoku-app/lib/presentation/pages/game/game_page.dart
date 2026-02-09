/// Game page.
///
/// The main game screen with Sudoku grid and controls.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../bloc/game/game_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../widgets/game/action_bar_widget.dart';
import '../../widgets/game/number_pad_widget.dart';
import '../../widgets/game/timer_widget.dart';
import '../../widgets/sudoku_grid/sudoku_grid_widget.dart';
import '../main_menu/main_menu_page.dart';
import '../win/win_page.dart';

/// {@template game_page}
/// The main game page where users play Sudoku.
///
/// Displays the Sudoku grid, timer, action buttons,
/// and number pad for entering values.
/// {@endtemplate}
class GamePage extends StatefulWidget {
  /// {@macro game_page}
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        final GameBlocState state = context.read<GameBloc>().state;
        if (state is GameActive) {
          context.read<GameBloc>().add(
                TimerTicked(state.gameState.elapsedSeconds + 1),
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.read<GameBloc>().add(const GameSaved());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Game saved')),
              );
            },
            tooltip: 'Save Game',
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => _showExitDialog(context),
            tooltip: 'Main Menu',
          ),
        ],
      ),
      body: BlocConsumer<GameBloc, GameBlocState>(
        listener: (BuildContext context, GameBlocState state) {
          if (state is GameOver) {
            _timer?.cancel();
            Navigator.pushReplacement<dynamic, dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => WinPage(
                  score: state.finalScore,
                  elapsedTime: state.elapsedTime,
                  difficulty: state.gameState.difficulty,
                ),
              ),
            );
          } else if (state is GameError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (BuildContext context, GameBlocState state) {
          if (state is GameLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GameActive) {
            return _buildGameContent(context, state);
          }

          if (state is GameInitial) {
            return const Center(
              child: Text('No active game. Start a new game from the menu.'),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGameContent(BuildContext context, GameActive state) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          // Game info bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Difficulty
                Chip(
                  label: Text(state.gameState.difficulty.label),
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withAlpha(128),
                ),

                // Timer
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (BuildContext context, SettingsState settingsState) {
                    if (settingsState is SettingsLoadedState &&
                        settingsState.settings.showTimer) {
                      return TimerWidget(
                        elapsedSeconds: state.gameState.elapsedSeconds,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          // Sudoku grid
          Expanded(
            flex: 3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SudokuGridWidget(
                  grid: state.gameState.grid,
                  selectedPosition: state.gameState.selectedPosition,
                  onCellTap: (Position position) {
                    context.read<GameBloc>().add(CellSelected(position));
                  },
                ),
              ),
            ),
          ),

          // Action bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ActionBarWidget(
              canUndo: state.canUndo,
              canRedo: state.canRedo,
              isNoteMode: state.isNoteMode,
              onUndo: () => context.read<GameBloc>().add(const UndoPressed()),
              onRedo: () => context.read<GameBloc>().add(const RedoPressed()),
              onErase: () => context.read<GameBloc>().add(const CellCleared()),
              onToggleNoteMode: () {
                // Note mode toggle would be implemented here
              },
            ),
          ),

          const SizedBox(height: 16),

          // Number pad
          Padding(
            padding: const EdgeInsets.all(16),
            child: NumberPadWidget(
              onNumberPressed: (int number) {
                context.read<GameBloc>().add(NumberEntered(number));
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context) async {
    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Game?'),
          content: const Text(
            'Do you want to save your progress before leaving?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Don\'t Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true && context.mounted) {
      context.read<GameBloc>().add(const GameSaved());
    }

    if (context.mounted) {
      Navigator.pushAndRemoveUntil<dynamic, dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const MainMenuPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
