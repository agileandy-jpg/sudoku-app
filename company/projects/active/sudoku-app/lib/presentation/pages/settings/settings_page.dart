/// Settings page.
///
/// Allows users to customize app preferences.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/entities.dart';
import '../../bloc/settings/settings_bloc.dart';

/// {@template settings_page}
/// Page for managing application settings.
///
/// Allows users to customize theme, game options,
/// and other preferences.
/// {@endtemplate}
class SettingsPage extends StatelessWidget {
  /// {@macro settings_page}
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsLoadedState) {
            return _buildSettingsContent(context, state);
          }

          if (state is SettingsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, SettingsLoadedState state) {
    final Settings settings = state.settings;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          // Theme section
          _SectionHeader(title: 'Appearance'),
          _ThemeSelector(
            currentTheme: settings.themeMode,
            onChanged: (ThemeMode mode) {
              context.read<SettingsBloc>().add(ThemeModeChanged(mode));
            },
          ),
          const SizedBox(height: 24),

          // Game options section
          _SectionHeader(title: 'Game Options'),
          _SwitchTile(
            title: 'Show Timer',
            subtitle: 'Display the game timer during play',
            value: settings.showTimer,
            onChanged: (bool value) {
              context.read<SettingsBloc>().add(ShowTimerToggled(value));
            },
          ),
          _SwitchTile(
            title: 'Auto-check Errors',
            subtitle: 'Highlight cells that violate Sudoku rules',
            value: settings.autoCheckErrors,
            onChanged: (bool value) {
              context.read<SettingsBloc>().add(AutoCheckErrorsToggled(value));
            },
          ),
          const SizedBox(height: 24),

          // Feedback section
          _SectionHeader(title: 'Feedback'),
          _SwitchTile(
            title: 'Haptic Feedback',
            subtitle: 'Vibrate on interactions',
            value: settings.enableHaptic,
            onChanged: (bool value) {
              context.read<SettingsBloc>().add(EnableHapticToggled(value));
            },
          ),
          _SwitchTile(
            title: 'Sound Effects',
            subtitle: 'Play sounds during gameplay',
            value: settings.soundEnabled,
            onChanged: (bool value) {
              context.read<SettingsBloc>().add(SoundEnabledToggled(value));
            },
          ),
          const SizedBox(height: 24),

          // Default difficulty
          _SectionHeader(title: 'Default Difficulty'),
          _DifficultySelector(
            currentDifficulty: settings.lastDifficulty,
            onChanged: (Difficulty difficulty) {
              context.read<SettingsBloc>().add(LastDifficultyChanged(difficulty));
            },
          ),
          const SizedBox(height: 24),

          // Reset button
          OutlinedButton.icon(
            onPressed: () {
              _showResetConfirmation(context);
            },
            icon: const Icon(Icons.restore),
            label: const Text('Reset to Defaults'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showResetConfirmation(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings?'),
          content: const Text(
            'This will reset all settings to their default values. '
            'This action cannot be undone.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<SettingsBloc>().add(const SettingsResetRequested());
    }
  }
}

/// Section header widget.
class _SectionHeader extends StatelessWidget {
  /// Creates a section header.
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}

/// Theme selector widget.
class _ThemeSelector extends StatelessWidget {
  /// Creates a theme selector.
  const _ThemeSelector({
    required this.currentTheme,
    required this.onChanged,
  });

  final ThemeMode currentTheme;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            subtitle: const Text('Follow system theme'),
            value: ThemeMode.system,
            groupValue: currentTheme,
            onChanged: (ThemeMode? value) {
              if (value != null) onChanged(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            subtitle: const Text('Always use light theme'),
            value: ThemeMode.light,
            groupValue: currentTheme,
            onChanged: (ThemeMode? value) {
              if (value != null) onChanged(value);
            },
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            subtitle: const Text('Always use dark theme'),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (ThemeMode? value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}

/// Switch tile widget.
class _SwitchTile extends StatelessWidget {
  /// Creates a switch tile.
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }
}

/// Difficulty selector widget.
class _DifficultySelector extends StatelessWidget {
  /// Creates a difficulty selector.
  const _DifficultySelector({
    required this.currentDifficulty,
    required this.onChanged,
  });

  final Difficulty currentDifficulty;
  final ValueChanged<Difficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: Difficulty.values.map((Difficulty difficulty) {
          return RadioListTile<Difficulty>(
            title: Text(difficulty.label),
            subtitle: Text(difficulty.estimatedTime),
            value: difficulty,
            groupValue: currentDifficulty,
            onChanged: (Difficulty? value) {
              if (value != null) onChanged(value);
            },
          );
        }).toList(),
      ),
    );
  }
}
