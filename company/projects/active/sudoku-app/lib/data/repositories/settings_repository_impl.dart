/// Settings repository implementation.
///
/// Implements [SettingsRepository] interface with local data persistence.
library;

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../models/settings_model.dart';

/// {@template settings_repository_impl}
/// Implementation of [SettingsRepository] that handles
/// settings persistence to local storage.
/// {@endtemplate}
class SettingsRepositoryImpl implements SettingsRepository {
  /// {@macro settings_repository_impl}
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final SettingsModel? settingsModel =
          await _localDataSource.getSettings();

      if (settingsModel == null) {
        // Return default settings if none exist
        return const Right(Settings());
      }

      return Right(settingsModel.toEntity());
    } on CacheException catch (e) {
      return const Left(SettingsFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveSettings(Settings settings) async {
    try {
      final SettingsModel settingsModel = SettingsModel.fromEntity(settings);
      await _localDataSource.saveSettings(settingsModel);
      return const Right(null);
    } on CacheException catch (e) {
      return const Left(SettingsFailure());
    }
  }

  @override
  Future<Either<Failure, Settings>> resetSettings() async {
    try {
      const Settings defaultSettings = Settings();
      final SettingsModel settingsModel =
          SettingsModel.fromEntity(defaultSettings);
      await _localDataSource.saveSettings(settingsModel);
      return const Right(defaultSettings);
    } on CacheException catch (e) {
      return const Left(SettingsFailure());
    }
  }
}
