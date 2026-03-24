import '../repositories/auth_repository.dart';

/// Use case: logout and clear tokens and cached user.
class LogoutUseCase {
  LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> call() => _repository.logout();
}
