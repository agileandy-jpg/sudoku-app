/// Settings BLoC.
///
/// Manages user settings and preferences.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/failures.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/repositories/settings_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

export 'settings_event.dart';
export 'settings_state.dart';

/// {@template settings_bloc}
/// BLoC that manages application settings and preferences.
///
/// Handles loading, saving, and updating user preferences
/// including theme mode, game options, and UI settings.
/// {@endtemplate}
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  /// {@macro settings_bloc}
  SettingsBloc({
    required SettingsRepository settingsRepository,
  })  : _settingsRepository = settingsRepository,
        super(const SettingsInitial()) {
    on<SettingsLoaded>(_onSettingsLoaded);
    on<ThemeModeChanged>(_onThemeModeChanged);
    on<ShowTimerToggled>(_onShowTimerToggled);
    on<AutoCheckErrorsToggled>(_onAutoCheckErrorsToggled);
    on<EnableHapticToggled>(_onEnableHapticToggled);
    on<SoundEnabledToggled>(_onSoundEnabledToggled);
    on<LastDifficultyChanged>(_onLastDifficultyChanged);
    on<SettingsResetRequested>(_onSettingsResetRequested);
    on<SettingsSaved>(_onSettingsSaved);

    // Load settings on initialization
    add(const SettingsLoaded());
  }

  final SettingsRepository _settingsRepository;

  Future<void> _onSettingsLoaded(
    SettingsLoaded event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await _settingsRepository.getSettings();

    await result.fold(
      (Failure failure) async {
        emit(SettingsError(message: failure.message));
      },
      (Settings settings) async {
        emit(SettingsLoadedState(settings: settings));
      },
    );
  }

  Future<void> _onThemeModeChanged(
    ThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final Settings newSettings = currentState.settings.copyWith(
      themeMode: event.themeMode,
    );

    await _saveSettings(newSettings);
    emit(SettingsLoadedState(settings: newSettings));
  }

  Future<void> _onShowTimerToggled(
    ShowTimerToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final Settings newSettings = currentState.settings.copyWith(
      showTimer: event.showTimer,
    );

    await _saveSettings(newSettings);
    emit(SettingsLoadedState(settings: newSettings));
  }

  Future<void> _onAutoCheckErrorsToggled(
    AutoCheckErrorsToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final Settings newSettings = currentState.settings.copyWith(
      autoCheckErrors: event.autoCheckErrors,
    );

    await _saveSettings(newSettings);
    emit(SettingsLoadedState(settings: newSettings));
  }

  Future<void> _onEnableHapticToggled(
    EnableHapticToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final Settings newSettings = currentState.settings.copyWith(
      enableHaptic: event.enableHaptic,
    );

    await _saveSettings(newSettings);
    emit(SettingsLoadedState(settings: newSettings));
  }

  Future<void> _onSoundEnabledToggled(
    SoundEnabledToggled event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final Settings newSettings = currentState.settings.copyWith(
      soundEnabled: event.soundEnabled,
    );

    await _saveSettings(newSettings);
    emit(SettingsLoadedState(settings: newSettings));
  }

  Future<void> _onLastDifficultyChanged(
    LastDifficultyChanged event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final Settings newSettings = currentState.settings.copyWith(
      lastDifficulty: event.difficulty,
    );

    await _saveSettings(newSettings);
    emit(SettingsLoadedState(settings: newSettings));
  }

  Future<void> _onSettingsResetRequested(
    SettingsResetRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());

    final result = await _settingsRepository.resetSettings();

    await result.fold(
      (Failure failure) async {
        emit(SettingsError(message: failure.message));
      },
      (Settings settings) async {
        emit(SettingsLoadedState(settings: settings));
      },
    );
  }

  Future<void> _onSettingsSaved(
    SettingsSaved event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is! SettingsLoadedState) return;

    final SettingsLoadedState currentState = state as SettingsLoadedState;
    final result = await _settingsRepository.saveSettings(
      currentState.settings,
    );

    await result.fold(
      (Failure failure) async {
        emit(SettingsError(
          message: failure.message,
          previousState: currentState,
        ));
      },
      (_) async {
        emit(SettingsLoadedState(settings: currentState.settings));
      },
    );
  }

  Future<void> _saveSettings(Settings settings) async {
    await _settingsRepository.saveSettings(settings);
  }
}
