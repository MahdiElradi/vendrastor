import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_token_storage.dart';

/// Secure token storage using flutter_secure_storage.
class AuthTokenStorageImpl implements AuthTokenStorage {
  AuthTokenStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  final FlutterSecureStorage _storage;

  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';

  @override
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);

  @override
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);

  @override
  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  @override
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  @override
  Future<void> clearTokens() => _storage.deleteAll();
}
