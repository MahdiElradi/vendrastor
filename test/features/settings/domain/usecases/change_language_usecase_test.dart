import 'package:vendrastor_app/features/settings/domain/repositories/settings_repository.dart';
import 'package:vendrastor_app/features/settings/domain/usecases/change_language_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late ChangeLanguageUseCase useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = ChangeLanguageUseCase(mockRepository);
  });

  test('should call repository setLanguageCode with given value', () async {
    when(() => mockRepository.setLanguageCode(any()))
        .thenAnswer((_) async => Future<void>.value());

    await useCase('ar');

    verify(() => mockRepository.setLanguageCode('ar')).called(1);
  });
}
