import '../../domain/entities/app_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._local);
  final SettingsLocalDataSource _local;

  @override
  Future<AppSettingsEntity> getSettings() => _local.getSettings();

  @override
  Future<void> setThemeMode(String themeMode) =>
      _local.setThemeMode(themeMode);

  @override
  Future<void> setLanguageCode(String languageCode) =>
      _local.setLanguageCode(languageCode);
}
