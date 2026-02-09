/// Timer widget.
///
/// Displays the elapsed game time.
library;

import 'package:flutter/material.dart';

/// {@template timer_widget}
/// Widget that displays the game timer.
///
/// Shows elapsed time in MM:SS format.
/// {@endtemplate}
class TimerWidget extends StatelessWidget {
  /// {@macro timer_widget}
  const TimerWidget({
    required this.elapsedSeconds,
    this.textStyle,
    super.key,
  });

  /// The elapsed time in seconds.
  final int elapsedSeconds;

  /// Optional custom text style.
  final TextStyle? textStyle;

  /// Formats seconds into MM:SS string.
  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.timer,
          size: 20,
          color: colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 4),
        Text(
          _formatTime(elapsedSeconds),
          style: textStyle ??
              TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
                fontFeatures: const <FontFeature>[
                  FontFeature.tabularFigures(),
                ],
              ),
        ),
      ],
    );
  }
}
