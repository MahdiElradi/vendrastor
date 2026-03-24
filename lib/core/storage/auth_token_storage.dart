/// Abstraction for secure storage of auth tokens (access/refresh).
/// Implementation can use flutter_secure_storage or Hive with encryption.
abstract class AuthTokenStorage {
  Future<void> saveAccessToken(String token);
  Future<void> saveRefreshToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}
