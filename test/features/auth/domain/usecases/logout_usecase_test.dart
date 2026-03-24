import 'package:vendrastor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vendrastor_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LogoutUseCase(mockRepository);
  });

  test('should call repository logout', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async => {});

    await useCase();

    verify(() => mockRepository.logout()).called(1);
  });
}
