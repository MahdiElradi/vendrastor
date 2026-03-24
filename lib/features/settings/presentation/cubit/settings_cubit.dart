import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_settings_entity.dart';
import '../../domain/usecases/change_language_usecase.dart';
import '../../domain/usecases/change_theme_mode_usecase.dart';
import '../../domain/usecases/get_saved_settings_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._getSavedSettingsUseCase,
    this._changeThemeModeUseCase,
    this._changeLanguageUseCase,
  ) : super(const SettingsState());

  final GetSavedSettingsUseCase _getSavedSettingsUseCase;
  final ChangeThemeModeUseCase _changeThemeModeUseCase;
  final ChangeLanguageUseCase _changeLanguageUseCase;

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _getSavedSettingsUseCase();
      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> setThemeMode(String themeMode) async {
    await _changeThemeModeUseCase(themeMode);
    emit(state.copyWith(
      settings: AppSettingsEntity(
        themeMode: themeMode,
        languageCode: state.languageCode,
      ),
    ));
  }

  Future<void> setLanguageCode(String languageCode) async {
    await _changeLanguageUseCase(languageCode);
    emit(state.copyWith(
      settings: AppSettingsEntity(
        themeMode: state.themeMode,
        languageCode: languageCode,
      ),
    ));
  }

  ThemeMode get themeMode {
    switch (state.themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Locale get locale {
    return Locale(state.languageCode);
  }
}
