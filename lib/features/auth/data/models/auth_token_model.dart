import '../../domain/entities/auth_token_entity.dart';

/// DTO for auth token response from backend.
class AuthTokenModel extends AuthTokenEntity {
  const AuthTokenModel({
    required super.accessToken,
    super.refreshToken,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json['access_token'] as String? ?? json['accessToken'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? json['refreshToken'] as String?,
    );
  }
}
