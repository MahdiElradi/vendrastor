import 'package:vendrastor_app/features/auth/domain/entities/user_entity.dart';
import 'package:vendrastor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vendrastor_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late GetProfileUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = GetProfileUseCase(mockRepository);
  });

  const tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  test('should get user profile from auth repository', () async {
    when(() => mockRepository.getProfile()).thenAnswer((_) async => tUser);

    final result = await useCase();

    expect(result, tUser);
    verify(() => mockRepository.getProfile()).called(1);
  });
}
