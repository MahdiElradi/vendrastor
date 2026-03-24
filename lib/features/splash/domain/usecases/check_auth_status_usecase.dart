import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

/// Use case: check token presence and optionally return cached user.
/// Returns [UserEntity] if session is valid (token + cached user), null otherwise.
class CheckAuthStatusUseCase {
  CheckAuthStatusUseCase(this._authRepository);
  final AuthRepository _authRepository;

  Future<UserEntity?> call() async {
    final user = await _authRepository.getCachedUser();
    return user;
  }
}
