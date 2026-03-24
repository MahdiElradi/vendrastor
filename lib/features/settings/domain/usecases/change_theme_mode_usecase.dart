import '../repositories/settings_repository.dart';

class ChangeThemeModeUseCase {
  ChangeThemeModeUseCase(this._repository);
  final SettingsRepository _repository;

  Future<void> call(String themeMode) => _repository.setThemeMode(themeMode);
}
