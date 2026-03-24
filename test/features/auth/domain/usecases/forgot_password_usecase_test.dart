import 'package:vendrastor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vendrastor_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ForgotPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ForgotPasswordUseCase(mockRepository);
  });

  test('should call repository forgotPassword', () async {
    when(
      () => mockRepository.forgotPassword(any()),
    ).thenAnswer((_) async => {});

    await useCase('test@example.com');

    verify(() => mockRepository.forgotPassword('test@example.com')).called(1);
  });
}
