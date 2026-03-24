import '../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);
  final AuthRepository _repository;

  Future<UserEntity> call() => _repository.getProfile();
}
