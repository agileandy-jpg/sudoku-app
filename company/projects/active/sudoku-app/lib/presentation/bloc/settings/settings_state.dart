/// Settings BLoC states.
///
/// Represents all possible states of the settings feature.
library;

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

/// {@template settings_state}
/// Base class for all settings states.
/// {@endtemplate}
abstract class SettingsState extends Equatable {
  /// {@macro settings_state}
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// {@template settings_initial}
/// Initial state before settings are loaded.
/// {@endtemplate}
class SettingsInitial extends SettingsState {
  /// {@macro settings_initial}
  const SettingsInitial();
}

/// {@template settings_loading}
/// State when settings are being loaded.
/// {@endtemplate}
class SettingsLoading extends SettingsState {
  /// {@macro settings_loading}
  const SettingsLoading();
}

/// {@template settings_loaded_state}
/// State representing loaded settings.
/// {@endtemplate}
class SettingsLoadedState extends SettingsState {
  /// {@macro settings_loaded_state}
  const SettingsLoadedState({
    required this.settings,
    this.hasChanges = false,
  });

  /// The current settings.
  final Settings settings;

  /// Whether there are unsaved changes.
  final bool hasChanges;

  @override
  List<Object?> get props => [settings, hasChanges];

  /// Creates a copy of this state with the given fields replaced.
  SettingsLoadedState copyWith({
    Settings? settings,
    bool? hasChanges,
  }) {
    return SettingsLoadedState(
      settings: settings ?? this.settings,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}

/// {@template settings_error}
/// State when an error occurs loading or saving settings.
/// {@endtemplate}
class SettingsError extends SettingsState {
  /// {@macro settings_error}
  const SettingsError({
    required this.message,
    this.previousState,
  });

  /// The error message.
  final String message;

  /// The previous state before the error.
  final SettingsState? previousState;

  @override
  List<Object?> get props => [message, previousState];
}
