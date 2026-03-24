import 'dart:convert';

import '../../../../core/error/error_mapper.dart';
import '../../../../core/storage/auth_token_storage.dart';
import '../../../../core/storage/hive_manager.dart';
import '../../domain/entities/auth_token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

/// Implements AuthRepository with Dio and AuthTokenStorage.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthTokenStorage tokenStorage,
  })  : _remote = remote,
        _tokenStorage = tokenStorage;

  final AuthRemoteDataSource _remote;
  final AuthTokenStorage _tokenStorage;

  static const String _userCacheKey = 'current_user';

  @override
  Future<(UserEntity, AuthTokenEntity)> login(
    String email,
    String password,
  ) async {
    try {
      final (userModel, tokenModel) =
          await _remote.login(email, password);
      await _tokenStorage.saveAccessToken(tokenModel.accessToken);
      if (tokenModel.refreshToken != null) {
        await _tokenStorage.saveRefreshToken(tokenModel.refreshToken!);
      }
      await _cacheUser(userModel);
      return (userModel, tokenModel);
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<(UserEntity, AuthTokenEntity)> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final (userModel, tokenModel) =
          await _remote.register(name, email, password);
      await _tokenStorage.saveAccessToken(tokenModel.accessToken);
      if (tokenModel.refreshToken != null) {
        await _tokenStorage.saveRefreshToken(tokenModel.refreshToken!);
      }
      await _cacheUser(userModel);
      return (userModel, tokenModel);
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _remote.forgotPassword(email);
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    await _clearCachedUser();
  }

  @override
  Future<UserEntity?> getCachedUser() async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken == null || accessToken.isEmpty) return null;
    final box = HiveManager.box<dynamic>(HiveBox.userProfile);
    final jsonStr = box.get(_userCacheKey) as String?;
    if (jsonStr == null) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<UserEntity> getProfile() async {
    try {
      final userModel = await _remote.getProfile();
      await _cacheUser(userModel);
      return userModel;
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<UserEntity> updateProfile({String? name}) async {
    try {
      final userModel = await _remote.updateProfile(name: name);
      await _cacheUser(userModel);
      return userModel;
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  Future<void> _cacheUser(UserModel user) async {
    final box = HiveManager.box<dynamic>(HiveBox.userProfile);
    await box.put(_userCacheKey, jsonEncode(user.toJson()));
  }

  Future<void> _clearCachedUser() async {
    final box = HiveManager.box<dynamic>(HiveBox.userProfile);
    await box.delete(_userCacheKey);
  }
}
