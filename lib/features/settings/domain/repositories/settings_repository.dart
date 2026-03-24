import '../entities/app_settings_entity.dart';

/// Contract for persisting and reading app settings (theme, language).
abstract class SettingsRepository {
  Future<AppSettingsEntity> getSettings();
  Future<void> setThemeMode(String themeMode);
  Future<void> setLanguageCode(String languageCode);
}
