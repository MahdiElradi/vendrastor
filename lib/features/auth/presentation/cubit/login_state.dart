import '../../../../core/error/failures.dart';

/// Login form state.
class LoginState {
  const LoginState({
    this.isLoading = false,
    this.failure,
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.showPassword = false,
  });

  final bool isLoading;
  final Failure? failure;
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool showPassword;

  LoginState copyWith({
    bool? isLoading,
    Failure? failure,
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? showPassword,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
