import 'package:vendrastor_app/features/auth/domain/entities/user_entity.dart';
import 'package:vendrastor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vendrastor_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late UpdateProfileUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = UpdateProfileUseCase(mockRepository);
  });

  const tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Updated Name',
  );

  test('should call repository updateProfile with name and return user',
      () async {
    when(() => mockRepository.updateProfile(name: any(named: 'name')))
        .thenAnswer((_) async => tUser);

    final result = await useCase(name: 'Updated Name');

    expect(result, tUser);
    verify(() => mockRepository.updateProfile(name: 'Updated Name')).called(1);
  });
}
