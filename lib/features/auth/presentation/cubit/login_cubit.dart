import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_cubit.dart';
import 'login_state.dart';

/// Handles login form and submission; updates AuthCubit on success.
class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required LoginUseCase loginUseCase,
    required AuthCubit authCubit,
  })  : _loginUseCase = loginUseCase,
        _authCubit = authCubit,
        super(const LoginState());

  final LoginUseCase _loginUseCase;
  final AuthCubit _authCubit;

  void setEmail(String value) {
    emit(state.copyWith(email: value, emailError: null, failure: null));
  }

  void setPassword(String value) {
    emit(state.copyWith(password: value, passwordError: null, failure: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(showPassword: !state.showPassword));
  }

  bool _validate() {
    String? emailError;
    String? passwordError;
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
    emit(state.copyWith(emailError: emailError, passwordError: passwordError));
    return emailError == null && passwordError == null;
  }

  Future<void> submit() async {
    if (!_validate()) return;
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final (user, _) = await _loginUseCase(state.email.trim(), state.password);
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
