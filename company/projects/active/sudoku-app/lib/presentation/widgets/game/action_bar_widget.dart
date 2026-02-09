/// Action bar widget.
///
/// Displays action buttons for the game screen.
library;

import 'package:flutter/material.dart';

/// {@template action_bar_widget}
/// Widget that displays game action buttons.
///
/// Includes undo, redo, erase, and note toggle buttons.
/// {@endtemplate}
class ActionBarWidget extends StatelessWidget {
  /// {@macro action_bar_widget}
  const ActionBarWidget({
    required this.canUndo,
    required this.canRedo,
    required this.isNoteMode,
    required this.onUndo,
    required this.onRedo,
    required this.onErase,
    required this.onToggleNoteMode,
    super.key,
  });

  /// Whether undo is available.
  final bool canUndo;

  /// Whether redo is available.
  final bool canRedo;

  /// Whether note mode is currently active.
  final bool isNoteMode;

  /// Callback when undo is pressed.
  final VoidCallback onUndo;

  /// Callback when redo is pressed.
  final VoidCallback onRedo;

  /// Callback when erase is pressed.
  final VoidCallback onErase;

  /// Callback when note mode is toggled.
  final VoidCallback onToggleNoteMode;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        // Undo button
        _ActionButton(
          icon: Icons.undo,
          label: 'Undo',
          onPressed: canUndo ? onUndo : null,
        ),

        // Redo button
        _ActionButton(
          icon: Icons.redo,
          label: 'Redo',
          onPressed: canRedo ? onRedo : null,
        ),

        // Erase button
        _ActionButton(
          icon: Icons.backspace,
          label: 'Erase',
          onPressed: onErase,
        ),

        // Note mode button
        _ActionButton(
          icon: Icons.edit_note,
          label: 'Notes',
          onPressed: onToggleNoteMode,
          isActive: isNoteMode,
        ),
      ],
    );
  }
}

/// Individual action button.
class _ActionButton extends StatelessWidget {
  /// Creates an action button.
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          color: isActive ? colorScheme.primary : colorScheme.onSurface,
          style: IconButton.styleFrom(
            backgroundColor: isActive
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest,
          ),
          tooltip: label,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: onPressed != null
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
