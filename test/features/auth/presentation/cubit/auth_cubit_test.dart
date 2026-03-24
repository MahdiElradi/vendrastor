import 'package:bloc_test/bloc_test.dart';
import 'package:vendrastor_app/features/auth/domain/entities/user_entity.dart';
import 'package:vendrastor_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late AuthCubit cubit;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    cubit = AuthCubit(mockLogoutUseCase);
  });

  tearDown(() => cubit.close());

  const tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  group('AuthCubit', () {
    test('initial state is AuthInitial', () {
      expect(cubit.state, const AuthInitial());
    });

    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when setAuthenticated is called',
      build: () => cubit,
      act: (c) => c.setAuthenticated(tUser),
      expect: () => [AuthAuthenticated(tUser)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthUnauthenticated when setUnauthenticated is called',
      build: () => cubit,
      act: (c) => c.setUnauthenticated(),
      expect: () => [const AuthUnauthenticated()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits AuthLoading when setLoading is called',
      build: () => cubit,
      act: (c) => c.setLoading(),
      expect: () => [const AuthLoading()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthUnauthenticated] when logout is called',
      build: () {
        when(() => mockLogoutUseCase()).thenAnswer((_) async => {});
        return cubit;
      },
      act: (c) => c.logout(),
      expect: () => [const AuthLoading(), const AuthUnauthenticated()],
    );
  });
}
