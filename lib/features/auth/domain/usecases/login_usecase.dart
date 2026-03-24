import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: login with email and password; returns user and tokens.
class LoginUseCase {
  LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<(UserEntity, AuthTokenEntity)> call(String email, String password) =>
      _repository.login(email, password);
}
