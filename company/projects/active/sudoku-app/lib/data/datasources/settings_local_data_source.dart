/// Settings local data source.
///
/// Interface and implementation for settings persistence.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failures.dart';
import '../models/settings_model.dart';

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
