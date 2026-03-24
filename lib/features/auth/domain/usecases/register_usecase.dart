import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case: register with name, email, password; returns user and tokens.
class RegisterUseCase {
  RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<(UserEntity, AuthTokenEntity)> call(
    String name,
    String email,
    String password,
  ) =>
      _repository.register(name, email, password);
}
