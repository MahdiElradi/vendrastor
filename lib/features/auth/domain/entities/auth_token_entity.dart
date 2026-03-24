/// Domain entity for JWT auth tokens.
class AuthTokenEntity {
  const AuthTokenEntity({
    required this.accessToken,
    this.refreshToken,
  });
  final String accessToken;
  final String? refreshToken;
}
