import 'package:flutter/material.dart';

import '../../domain/entities/app_settings_entity.dart';

class SettingsState {
  const SettingsState({
    this.settings = const AppSettingsEntity(),
    this.isLoading = false,
  });

  final AppSettingsEntity settings;
  final bool isLoading;

  String get themeMode => settings.themeMode;
  String get languageCode => settings.languageCode;

  ThemeMode get themeModeEnum {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Locale get locale => Locale(languageCode);

  SettingsState copyWith({AppSettingsEntity? settings, bool? isLoading}) {
    return SettingsState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsState &&
          settings == other.settings &&
          isLoading == other.isLoading;

  @override
  int get hashCode => Object.hash(settings, isLoading);
}
