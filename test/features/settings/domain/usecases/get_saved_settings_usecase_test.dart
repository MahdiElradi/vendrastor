import 'package:vendrastor_app/features/settings/domain/entities/app_settings_entity.dart';
import 'package:vendrastor_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:vendrastor_app/features/settings/domain/usecases/get_saved_settings_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late GetSavedSettingsUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetSavedSettingsUseCase(mockRepository);
  });

  const tSettings = AppSettingsEntity(
    themeMode: 'dark',
    languageCode: 'ar',
  );

  test('should get settings from repository', () async {
    when(() => mockRepository.getSettings())
        .thenAnswer((_) async => tSettings);

    final result = await useCase();

    expect(result, tSettings);
    verify(() => mockRepository.getSettings()).called(1);
  });
}
