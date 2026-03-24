import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
    this._logoutUseCase,
    this._authCubit,
  ) : super(const ProfileState());

  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final AuthCubit _authCubit;

  Future<void> loadProfile() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await _getProfileUseCase();
      emit(state.copyWith(user: user, isLoading: false));
    } catch (e) {
      final message = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      emit(state.copyWith(isLoading: false, errorMessage: message));
    }
  }

  Future<void> updateProfile({String? name}) async {
    if (name == null || name.isEmpty) return;
    emit(state.copyWith(isUpdating: true, errorMessage: null));
    try {
      final user = await _updateProfileUseCase(name: name);
      emit(
        state.copyWith(
          user: user,
          isUpdating: false,
          successMessage: 'Profile updated',
        ),
      );
    } catch (e) {
      final message = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      emit(state.copyWith(isUpdating: false, errorMessage: message));
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    _authCubit.logout();
  }
}
