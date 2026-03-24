import 'package:bloc_test/bloc_test.dart';
import 'package:vendrastor_app/features/settings/domain/entities/app_settings_entity.dart';
import 'package:vendrastor_app/features/settings/domain/usecases/change_language_usecase.dart';
import 'package:vendrastor_app/features/settings/domain/usecases/change_theme_mode_usecase.dart';
import 'package:vendrastor_app/features/settings/domain/usecases/get_saved_settings_usecase.dart';
import 'package:vendrastor_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:vendrastor_app/features/settings/presentation/cubit/settings_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSavedSettingsUseCase extends Mock
    implements GetSavedSettingsUseCase {}

class MockChangeThemeModeUseCase extends Mock implements ChangeThemeModeUseCase {}

class MockChangeLanguageUseCase extends Mock implements ChangeLanguageUseCase {}

void main() {
  late SettingsCubit cubit;
  late MockGetSavedSettingsUseCase mockGetSettings;
  late MockChangeThemeModeUseCase mockChangeTheme;
  late MockChangeLanguageUseCase mockChangeLanguage;

  setUp(() {
    mockGetSettings = MockGetSavedSettingsUseCase();
    mockChangeTheme = MockChangeThemeModeUseCase();
    mockChangeLanguage = MockChangeLanguageUseCase();
    cubit = SettingsCubit(
      mockGetSettings,
      mockChangeTheme,
      mockChangeLanguage,
    );
  });

  tearDown(() => cubit.close());

  const initialSettings = AppSettingsEntity(
    themeMode: 'system',
    languageCode: 'en',
  );

  const loadedSettings = AppSettingsEntity(
    themeMode: 'dark',
    languageCode: 'ar',
  );

  blocTest<SettingsCubit, SettingsState>(
    'emits [loading, then state with settings] when loadSettings is called',
    build: () {
      when(() => mockGetSettings()).thenAnswer((_) async => loadedSettings);
      return cubit;
    },
    act: (c) => c.loadSettings(),
    expect: () => [
      const SettingsState(isLoading: true),
      SettingsState(settings: loadedSettings, isLoading: false),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'emits state with new themeMode when setThemeMode is called',
    build: () {
      when(() => mockChangeTheme(any())).thenAnswer((_) async => {});
      return cubit;
    },
    seed: () => const SettingsState(settings: initialSettings),
    act: (c) => c.setThemeMode('dark'),
    expect: () => [
      SettingsState(
        settings: const AppSettingsEntity(
          themeMode: 'dark',
          languageCode: 'en',
        ),
      ),
    ],
  );

  blocTest<SettingsCubit, SettingsState>(
    'emits state with new languageCode when setLanguageCode is called',
    build: () {
      when(() => mockChangeLanguage(any())).thenAnswer((_) async => {});
      return cubit;
    },
    seed: () => const SettingsState(settings: initialSettings),
    act: (c) => c.setLanguageCode('ar'),
    expect: () => [
      const SettingsState(
        settings: AppSettingsEntity(
          themeMode: 'system',
          languageCode: 'ar',
        ),
      ),
    ],
  );
}
