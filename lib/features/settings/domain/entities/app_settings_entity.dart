/// Theme mode and language preferences.
class AppSettingsEntity {
  const AppSettingsEntity({
    this.themeMode = 'system',
    this.languageCode = 'en',
  });
  final String themeMode;
  final String languageCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsEntity &&
          themeMode == other.themeMode &&
          languageCode == other.languageCode;

  @override
  int get hashCode => Object.hash(themeMode, languageCode);
}
