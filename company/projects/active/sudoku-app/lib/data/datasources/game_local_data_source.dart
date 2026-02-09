/// Data sources for local storage operations.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../models/models.dart';

/// {@template game_local_data_source}
/// Interface for local game data storage.
/// 
/// Handles persistence of game state to local storage.
/// {@endtemplate}
abstract class GameLocalDataSource {
  /// Saves a game to local storage.
  /// 
  /// [gameModel] The game to save.
  /// 
  /// Throws [CacheException] if saving fails.
  Future<void> saveGame(GameModel gameModel);

  /// Loads a saved game from local storage.
  /// 
  /// Returns the saved game, or null if no game exists.
  /// 
  /// Throws [CacheException] if loading fails.
  Future<GameModel?> getSavedGame();

  /// Clears the saved game from local storage.
  /// 
  /// Throws [CacheException] if clearing fails.
  Future<void> clearSavedGame();
}

/// {@template game_local_data_source_impl}
/// Implementation of [GameLocalDataSource] using SharedPreferences.
/// {@endtemplate}
class GameLocalDataSourceImpl implements GameLocalDataSource {
  /// {@macro game_local_data_source_impl}
  const GameLocalDataSourceImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<void> saveGame(GameModel gameModel) async {
    try {
      final String json = jsonEncode(gameModel.toJson());
      final bool success = await _preferences.setString(
        StorageKeys.currentGame,
        json,
      );
      if (!success) {
        throw const CacheException('Failed to save game');
      }
    } catch (e) {
      throw CacheException('Failed to save game: $e');
    }
  }

  @override
  Future<GameModel?> getSavedGame() async {
    try {
      final String? json = _preferences.getString(StorageKeys.currentGame);
      if (json == null) {
        return null;
      }
      final Map<String, dynamic> data =
          jsonDecode(json) as Map<String, dynamic>;
      return GameModel.fromJson(data);
    } catch (e) {
      throw CacheException('Failed to load game: $e');
    }
  }

  @override
  Future<void> clearSavedGame() async {
    try {
      final bool success = await _preferences.remove(StorageKeys.currentGame);
      if (!success) {
        throw const CacheException('Failed to clear saved game');
      }
    } catch (e) {
      throw CacheException('Failed to clear saved game: $e');
    }
  }
}

/// {@template settings_local_data_source}
/// Interface for local settings storage.
/// 
/// Handles persistence of user settings to local storage.
/// {@endtemplate}
abstract class SettingsLocalDataSource {
  /// Saves settings to local storage.
  /// 
  /// [settingsModel] The settings to save.
  /// 
  /// Throws [CacheException] if saving fails.
  Future<void> saveSettings(SettingsModel settingsModel);

  /// Loads settings from local storage.
  /// 
  /// Returns the saved settings, or null if no settings exist.
  /// 
  /// Throws [CacheException] if loading fails.
  Future<SettingsModel?> getSettings();

  /// Clears settings from local storage.
  /// 
  /// Throws [CacheException] if clearing fails.
  Future<void> clearSettings();
}

/// {@template settings_local_data_source_impl}
/// Implementation of [SettingsLocalDataSource] using SharedPreferences.
/// {@endtemplate}
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  /// {@macro settings_local_data_source_impl}
  const SettingsLocalDataSourceImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<void> saveSettings(SettingsModel settingsModel) async {
    try {
      final String json = jsonEncode(settingsModel.toJson());
      final bool success = await _preferences.setString(
        StorageKeys.settings,
        json,
      );
      if (!success) {
        throw const CacheException('Failed to save settings');
      }
    } catch (e) {
      throw CacheException('Failed to save settings: $e');
    }
  }

  @override
  Future<SettingsModel?> getSettings() async {
    try {
      final String? json = _preferences.getString(StorageKeys.settings);
      if (json == null) {
        return null;
      }
      final Map<String, dynamic> data =
          jsonDecode(json) as Map<String, dynamic>;
      return SettingsModel.fromJson(data);
    } catch (e) {
      throw CacheException('Failed to load settings: $e');
    }
  }

  @override
  Future<void> clearSettings() async {
    try {
      final bool success = await _preferences.remove(StorageKeys.settings);
      if (!success) {
        throw const CacheException('Failed to clear settings');
      }
    } catch (e) {
      throw CacheException('Failed to clear settings: $e');
    }
  }
}
