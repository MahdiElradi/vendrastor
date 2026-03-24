import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_cubit.dart';
import 'register_state.dart';

/// Handles register form and submission; updates AuthCubit on success.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({
    required RegisterUseCase registerUseCase,
    required AuthCubit authCubit,
  })  : _registerUseCase = registerUseCase,
        _authCubit = authCubit,
        super(const RegisterState());

  final RegisterUseCase _registerUseCase;
  final AuthCubit _authCubit;

  void setName(String value) {
    emit(state.copyWith(name: value, nameError: null, failure: null));
  }

  void setEmail(String value) {
    emit(state.copyWith(email: value, emailError: null, failure: null));
  }

  void setPassword(String value) {
    emit(state.copyWith(password: value, passwordError: null, failure: null));
  }

  void setConfirmPassword(String value) {
    emit(state.copyWith(
      confirmPassword: value,
      confirmPasswordError: null,
      failure: null,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  bool _validate() {
    String? nameError;
    String? emailError;
    String? passwordError;
    String? confirmPasswordError;
    if (state.name.trim().isEmpty) {
      nameError = 'Name is required';
    }
    if (state.email.trim().isEmpty) {
      emailError = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(state.email.trim())) {
      emailError = 'Enter a valid email';
    }
    if (state.password.isEmpty) {
      passwordError = 'Password is required';
    } else if (state.password.length < 6) {
      passwordError = 'Password must be at least 6 characters';
    } else if (state.password.length > 20) {
      passwordError = 'Password must be at most 20 characters';
    }
    if (state.confirmPassword != state.password) {
      confirmPasswordError = 'Passwords do not match';
    }
    emit(state.copyWith(
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
    ));
    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  Future<void> submit() async {
    if (!_validate()) return;
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final (user, _) = await _registerUseCase(
        state.name.trim(),
        state.email.trim(),
        state.password,
      );
      _authCubit.setAuthenticated(user);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        failure: e is Failure ? e : ServerFailure(e.toString()),
      ));
    }
  }
}
