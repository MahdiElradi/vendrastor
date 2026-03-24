import '../entities/auth_token_entity.dart';
import '../entities/user_entity.dart';

/// Contract for auth operations (login, register, logout).
abstract class AuthRepository {
  Future<(UserEntity, AuthTokenEntity)> login(String email, String password);
  Future<(UserEntity, AuthTokenEntity)> register(
    String name,
    String email,
    String password,
  );
  Future<void> forgotPassword(String email);
  Future<void> logout();

  /// Returns the currently cached user if any (e.g. after app restart with valid token).
  Future<UserEntity?> getCachedUser();

  /// Fetches current user profile from API and updates cache.
  Future<UserEntity> getProfile();

  /// Updates profile (e.g. name) and returns updated user.
  Future<UserEntity> updateProfile({String? name});
}
