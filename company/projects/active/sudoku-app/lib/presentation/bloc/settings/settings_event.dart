/// Settings BLoC events.
///
/// Defines all user actions that can trigger settings state changes.
library;

import 'package:equatable/equatable.dart';

import '../../../domain/entities/entities.dart';

/// {@template settings_event}
/// Base class for all settings events.
/// {@endtemplate}
abstract class SettingsEvent extends Equatable {
  /// {@macro settings_event}
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// {@template settings_loaded}
/// Event triggered when settings should be loaded from storage.
/// {@endtemplate}
class SettingsLoaded extends SettingsEvent {
  /// {@macro settings_loaded}
  const SettingsLoaded();
}

/// {@template theme_mode_changed}
/// Event triggered when the theme mode is changed.
/// {@endtemplate}
class ThemeModeChanged extends SettingsEvent {
  /// {@macro theme_mode_changed}
  const ThemeModeChanged(this.themeMode);

  /// The new theme mode.
  final ThemeMode themeMode;

  @override
  List<Object?> get props => [themeMode];
}

/// {@template show_timer_toggled}
/// Event triggered when the show timer setting is toggled.
/// {@endtemplate}
class ShowTimerToggled extends SettingsEvent {
  /// {@macro show_timer_toggled}
  const ShowTimerToggled(this.showTimer);

  /// Whether to show the timer.
  final bool showTimer;

  @override
  List<Object?> get props => [showTimer];
}

/// {@template auto_check_errors_toggled}
/// Event triggered when the auto check errors setting is toggled.
/// {@endtemplate}
class AutoCheckErrorsToggled extends SettingsEvent {
  /// {@macro auto_check_errors_toggled}
  const AutoCheckErrorsToggled(this.autoCheckErrors);

  /// Whether to auto check errors.
  final bool autoCheckErrors;

  @override
  List<Object?> get props => [autoCheckErrors];
}

/// {@template enable_haptic_toggled}
/// Event triggered when the haptic feedback setting is toggled.
/// {@endtemplate}
class EnableHapticToggled extends SettingsEvent {
  /// {@macro enable_haptic_toggled}
  const EnableHapticToggled(this.enableHaptic);

  /// Whether to enable haptic feedback.
  final bool enableHaptic;

  @override
  List<Object?> get props => [enableHaptic];
}

/// {@template sound_enabled_toggled}
/// Event triggered when the sound enabled setting is toggled.
/// {@endtemplate}
class SoundEnabledToggled extends SettingsEvent {
  /// {@macro sound_enabled_toggled}
  const SoundEnabledToggled(this.soundEnabled);

  /// Whether sound effects are enabled.
  final bool soundEnabled;

  @override
  List<Object?> get props => [soundEnabled];
}

/// {@template last_difficulty_changed}
/// Event triggered when the last difficulty is changed.
/// {@endtemplate}
class LastDifficultyChanged extends SettingsEvent {
  /// {@macro last_difficulty_changed}
  const LastDifficultyChanged(this.difficulty);

  /// The new difficulty.
  final Difficulty difficulty;

  @override
  List<Object?> get props => [difficulty];
}

/// {@template settings_reset_requested}
/// Event triggered when settings should be reset to defaults.
/// {@endtemplate}
class SettingsResetRequested extends SettingsEvent {
  /// {@macro settings_reset_requested}
  const SettingsResetRequested();
}

/// {@template settings_saved}
/// Event triggered when settings should be saved to storage.
/// {@endtemplate}
class SettingsSaved extends SettingsEvent {
  /// {@macro settings_saved}
  const SettingsSaved();
}
