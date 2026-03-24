import 'package:bloc_test/bloc_test.dart';
import 'package:vendrastor_app/features/auth/domain/entities/user_entity.dart';
import 'package:vendrastor_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:vendrastor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:vendrastor_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:vendrastor_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:vendrastor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:vendrastor_app/features/profile/presentation/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late ProfileCubit cubit;
  late MockGetProfileUseCase mockGetProfile;
  late MockUpdateProfileUseCase mockUpdateProfile;
  late MockLogoutUseCase mockLogout;
  late MockAuthCubit mockAuthCubit;

  const tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  );

  setUp(() {
    mockGetProfile = MockGetProfileUseCase();
    mockUpdateProfile = MockUpdateProfileUseCase();
    mockLogout = MockLogoutUseCase();
    mockAuthCubit = MockAuthCubit();
    cubit = ProfileCubit(
      mockGetProfile,
      mockUpdateProfile,
      mockLogout,
      mockAuthCubit,
    );
  });

  tearDown(() => cubit.close());

  blocTest<ProfileCubit, ProfileState>(
    'emits [loading, then state with user] when loadProfile succeeds',
    build: () {
      when(() => mockGetProfile()).thenAnswer((_) async => tUser);
      return cubit;
    },
    act: (c) => c.loadProfile(),
    expect: () => [
      const ProfileState(isLoading: true),
      const ProfileState(user: tUser, isLoading: false),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'emits [loading, then state with errorMessage] when loadProfile fails',
    build: () {
      when(() => mockGetProfile()).thenThrow(Exception('Network error'));
      return cubit;
    },
    act: (c) => c.loadProfile(),
    expect: () => [
      const ProfileState(isLoading: true),
      const ProfileState(
        isLoading: false,
        errorMessage: 'Network error',
      ),
    ],
  );

  blocTest<ProfileCubit, ProfileState>(
    'emits [isUpdating, then state with updated user and success] when updateProfile succeeds',
    build: () {
      when(() => mockUpdateProfile(name: any(named: 'name')))
          .thenAnswer((_) async => tUser);
      return cubit;
    },
    seed: () => const ProfileState(user: tUser),
    act: (c) => c.updateProfile(name: 'New Name'),
    expect: () => [
      const ProfileState(
        user: tUser,
        isUpdating: true,
      ),
      const ProfileState(
        user: tUser,
        isUpdating: false,
        successMessage: 'Profile updated',
      ),
    ],
  );
}
