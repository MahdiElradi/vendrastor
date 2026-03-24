import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Maps Dio errors and data-layer exceptions to domain Failures.
class ErrorMapper {
  ErrorMapper._();

  static Failure fromDioException(DioException err) {
    final status = err.response?.statusCode;
    final message = _messageFromResponse(err.response) ??
        err.message ??
        'Something went wrong';

    if (status == 401 || status == 403) {
      return AuthFailure(message);
    }
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      return NetworkFailure(message);
    }
    if (status != null && status >= 400 && status < 500) {
      return ValidationFailure(message);
    }
    return ServerFailure(message);
  }

  static Failure fromException(Object e) {
    if (e is UnauthorizedException) {
      return AuthFailure(e.message);
    }
    if (e is NetworkException) {
      return NetworkFailure(e.message);
    }
    if (e is ServerException) {
      return ServerFailure(e.message);
    }
    if (e is CacheException) {
      return CacheFailure(e.message);
    }
    if (e is DioException) {
      return fromDioException(e);
    }
    return ServerFailure(e.toString());
  }

  static String? _messageFromResponse(Response<dynamic>? response) {
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
