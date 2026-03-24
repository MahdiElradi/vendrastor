import '../../../../core/error/failures.dart';

/// Register form state.
class RegisterState {
  const RegisterState({
    this.isLoading = false,
    this.failure,
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.nameError,
    this.emailError,
    this.passwordError,
    this.confirmPasswordError,
    this.showPassword = false,
  });

  final bool isLoading;
  final Failure? failure;
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? confirmPasswordError;
  final bool showPassword;

  RegisterState copyWith({
    bool? isLoading,
    Failure? failure,
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? nameError,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    bool? showPassword,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nameError: nameError,
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      showPassword: showPassword ?? this.showPassword,
    );
  }
}
