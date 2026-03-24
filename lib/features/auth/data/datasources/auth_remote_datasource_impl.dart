import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Dio-based implementation of AuthRemoteDataSource.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<(UserModel, AuthTokenModel)> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: <String, dynamic>{
          'email': email,
          'password': password,
        },
      );
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<(UserModel, AuthTokenModel)> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: <String, dynamic>{
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return _parseAuthResponse(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.forgotPassword,
        data: <String, dynamic>{'email': email},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.profile);
      final data = response.data;
      if (data == null) throw const ServerException('Invalid response');
      final map = data['data'] as Map<String, dynamic>? ?? data;
      final userJson = map['user'] as Map<String, dynamic>? ?? map;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<UserModel> updateProfile({String? name}) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.profile,
        data: <String, dynamic>{if (name != null) 'name': name},
      );
      final data = response.data;
      if (data == null) throw const ServerException('Invalid response');
      final map = data['data'] as Map<String, dynamic>? ?? data;
      final userJson = map['user'] as Map<String, dynamic>? ?? map;
      return UserModel.fromJson(userJson);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  (UserModel, AuthTokenModel) _parseAuthResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const ServerException('Invalid response');
    }
    // Support both top-level and nested "data" wrapper
    final map = data['data'] as Map<String, dynamic>? ?? data;
    final userJson = map['user'] as Map<String, dynamic>? ?? map;
    final user = UserModel.fromJson(userJson);
    final token = AuthTokenModel.fromJson(map);
    return (user, token);
  }

  Never _mapDioException(DioException e) {
    final status = e.response?.statusCode;
    final message = _messageFromResponse(e.response) ?? e.message ?? 'Request failed';
    if (status == 401) throw UnauthorizedException(message);
    if (status == 403) throw ForbiddenException(message);
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw NetworkException(message);
    }
    throw ServerException(message);
  }

  String? _messageFromResponse(Response<dynamic>? response) {
    if (response?.data == null) return null;
    final data = response!.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
    }
    if (data is String) return data;
    return null;
  }
}
