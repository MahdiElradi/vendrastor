import '../../../../core/storage/hive_manager.dart';
import '../../domain/entities/app_settings_entity.dart';
import 'settings_local_datasource.dart';

const String _keyThemeMode = 'theme_mode';
const String _keyLanguageCode = 'language_code';
const String _defaultThemeMode = 'system';
const String _defaultLanguageCode = 'en';

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  @override
  Future<AppSettingsEntity> getSettings() async {
    final box = HiveManager.settingsBox();
    final themeMode = box.get(_keyThemeMode) as String? ?? _defaultThemeMode;
    final languageCode =
        box.get(_keyLanguageCode) as String? ?? _defaultLanguageCode;
    return AppSettingsEntity(
      themeMode: themeMode,
      languageCode: languageCode,
    );
  }

  @override
  Future<void> setThemeMode(String themeMode) async {
    final box = HiveManager.settingsBox();
    await box.put(_keyThemeMode, themeMode);
  }

  @override
  Future<void> setLanguageCode(String languageCode) async {
    final box = HiveManager.settingsBox();
    await box.put(_keyLanguageCode, languageCode);
  }
}
