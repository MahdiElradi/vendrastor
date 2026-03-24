import '../repositories/auth_repository.dart';

/// Use case: request password reset for the given email.
class ForgotPasswordUseCase {
  ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call(String email) => _repository.forgotPassword(email);
}
