import '../../domain/entities/app_settings_entity.dart';

abstract class SettingsLocalDataSource {
  Future<AppSettingsEntity> getSettings();
  Future<void> setThemeMode(String themeMode);
  Future<void> setLanguageCode(String languageCode);
}
