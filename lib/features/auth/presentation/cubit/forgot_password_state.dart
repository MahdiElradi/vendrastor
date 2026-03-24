import '../../../../core/error/failures.dart';

/// Forgot password state.
class ForgotPasswordState {
  const ForgotPasswordState({
    this.isLoading = false,
    this.failure,
    this.success = false,
    this.email = '',
    this.emailError,
  });

  final bool isLoading;
  final Failure? failure;
  final bool success;
  final String email;
  final String? emailError;

  ForgotPasswordState copyWith({
    bool? isLoading,
    Failure? failure,
    bool? success,
    String? email,
    String? emailError,
  }) {
    return ForgotPasswordState(
      isLoading: isLoading ?? this.isLoading,
      failure: failure,
      success: success ?? this.success,
      email: email ?? this.email,
      emailError: emailError,
    );
  }
}
