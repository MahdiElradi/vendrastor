import 'package:dio/dio.dart';

import '../config/env_config.dart';
import '../storage/auth_token_storage.dart';

/// Configured Dio instance with base URL, timeouts, JWT injection, and auth error handling.
class DioClient {
  DioClient({
    required AuthTokenStorage authTokenStorage,
    Dio? dio,
    void Function(DioException, ErrorInterceptorHandler)? onAuthError,
  }) : _onAuthError = onAuthError {
    _dio = dio ?? Dio(_baseOptions);
    _dio.interceptors.addAll(_interceptors(authTokenStorage, onAuthError));
  }

  final void Function(DioException, ErrorInterceptorHandler)? _onAuthError;
  late final Dio _dio;

  BaseOptions get _baseOptions => BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout:
            Duration(milliseconds: EnvConfig.connectTimeoutMs),
        receiveTimeout:
            Duration(milliseconds: EnvConfig.receiveTimeoutMs),
        sendTimeout: Duration(milliseconds: EnvConfig.sendTimeoutMs),
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

  List<Interceptor> _interceptors(
    AuthTokenStorage authTokenStorage,
    void Function(DioException, ErrorInterceptorHandler)? onAuthError,
  ) {
    return <Interceptor>[
      InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
          final token = await authTokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
      if (EnvConfig.enableLogging)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      InterceptorsWrapper(
        onError: (DioException err, ErrorInterceptorHandler handler) async {
          final status = err.response?.statusCode;
          if (status == 401 || status == 403) {
            final onAuthError = _onAuthError;
            if (onAuthError != null) {
              onAuthError(err, handler);
              return;
            }
            await authTokenStorage.clearTokens();
          }
          handler.next(err);
        },
      ),
    ];
  }

  Dio get dio => _dio;

  String get baseUrl => EnvConfig.baseUrl;
}
