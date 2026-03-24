import 'package:vendrastor_app/features/auth/domain/entities/auth_token_entity.dart';
import 'package:vendrastor_app/features/auth/domain/entities/user_entity.dart';
import 'package:vendrastor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vendrastor_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  const tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );
  const tToken = AuthTokenEntity(
    accessToken: 'access',
    refreshToken: 'refresh',
  );

  test('should call repository register and return user and token', () async {
    when(
      () => mockRepository.register(any(), any(), any()),
    ).thenAnswer((_) async => (tUser, tToken));

    final result = await useCase(
      'Test User',
      'test@example.com',
      'password123',
    );

    expect(result.$1, tUser);
    expect(result.$2, tToken);
    verify(
      () => mockRepository.register(
        'Test User',
        'test@example.com',
        'password123',
      ),
    ).called(1);
  });
}
