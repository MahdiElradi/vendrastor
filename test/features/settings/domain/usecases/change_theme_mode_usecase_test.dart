import 'package:vendrastor_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:vendrastor_app/features/settings/domain/usecases/change_theme_mode_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ChangeThemeModeUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = ChangeThemeModeUseCase(mockRepository);
  });

  test('should call repository setThemeMode with given value', () async {
    when(() => mockRepository.setThemeMode(any()))
        .thenAnswer((_) async => Future<void>.value());

    await useCase('dark');

    verify(() => mockRepository.setThemeMode('dark')).called(1);
  });
}
