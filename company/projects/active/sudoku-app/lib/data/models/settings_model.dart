/// Settings model for JSON serialization.
///
/// Represents user settings for data transfer.
library;

import '../../domain/entities/entities.dart';

/// {@template settings_model}
/// Model class for serializing and deserializing [Settings] entities.
///
/// Converts between [Settings] domain entities and JSON-compatible maps.
/// Used for persisting user preferences to local storage.
/// {@endtemplate}
class SettingsModel {
  /// {@macro settings_model}
  const SettingsModel({
    required this.themeMode,
    required this.showTimer,
    required this.autoCheckErrors,
    required this.enableHaptic,
    required this.soundEnabled,
    required this.lastDifficulty,
  });

  /// Creates a [SettingsModel] from a domain [Settings] entity.
  ///
  /// [settings] The domain entity to convert.
  factory SettingsModel.fromEntity(Settings settings) {
    return SettingsModel(
      themeMode: settings.themeMode.name,
      showTimer: settings.showTimer,
      autoCheckErrors: settings.autoCheckErrors,
      enableHaptic: settings.enableHaptic,
      soundEnabled: settings.soundEnabled,
      lastDifficulty: settings.lastDifficulty.name,
    );
  }

  /// Creates a [SettingsModel] from a JSON map.
  ///
  /// [json] The JSON map to deserialize.
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeMode: json['themeMode'] as String? ?? 'system',
      showTimer: json['showTimer'] as bool? ?? true,
      autoCheckErrors: json['autoCheckErrors'] as bool? ?? true,
      enableHaptic: json['enableHaptic'] as bool? ?? true,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      lastDifficulty: json['lastDifficulty'] as String? ?? 'medium',
    );
  }

  /// The theme mode name ('system', 'light', or 'dark').
  final String themeMode;

  /// Whether to show the game timer.
  final bool showTimer;

  /// Whether to automatically highlight errors.
  final bool autoCheckErrors;

  /// Whether to enable haptic feedback.
  final bool enableHaptic;

  /// Whether sound effects are enabled.
  final bool soundEnabled;

  /// The last selected difficulty name.
  final String lastDifficulty;

  /// Converts this model to a domain [Settings] entity.
  Settings toEntity() {
    return Settings(
      themeMode: _parseThemeMode(themeMode),
      showTimer: showTimer,
      autoCheckErrors: autoCheckErrors,
      enableHaptic: enableHaptic,
      soundEnabled: soundEnabled,
      lastDifficulty: _parseDifficulty(lastDifficulty),
    );
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'themeMode': themeMode,
      'showTimer': showTimer,
      'autoCheckErrors': autoCheckErrors,
      'enableHaptic': enableHaptic,
      'soundEnabled': soundEnabled,
      'lastDifficulty': lastDifficulty,
    };
  }

  /// Parses a theme mode string into a [ThemeMode] enum value.
  ThemeMode _parseThemeMode(String name) {
    return ThemeMode.values.firstWhere(
      (ThemeMode t) => t.name == name,
      orElse: () => ThemeMode.system,
    );
  }

  /// Parses a difficulty string into a [Difficulty] enum value.
  Difficulty _parseDifficulty(String name) {
    return Difficulty.values.firstWhere(
      (Difficulty d) => d.name == name,
      orElse: () => Difficulty.medium,
    );
  }
}
