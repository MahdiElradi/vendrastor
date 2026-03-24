import '../../../../features/auth/domain/entities/user_entity.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';

class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);
  final AuthRepository _repository;

  Future<UserEntity> call({String? name}) =>
      _repository.updateProfile(name: name);
}
