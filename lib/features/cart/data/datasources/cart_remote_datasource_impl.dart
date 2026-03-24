import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/cart_item_model.dart';
import 'cart_remote_datasource.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final response =
          await _dio.get<Map<String, dynamic>>(ApiEndpoints.cart);
      final list = _extractList(response.data);
      return list
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> addItem(String productId, int quantity) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.cart,
        data: <String, dynamic>{
          'product_id': productId,
          'quantity': quantity,
        },
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> removeItem(String productId) async {
    try {
      await _dio.delete<Map<String, dynamic>>(
        '${ApiEndpoints.cart}/$productId',
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> updateItemQuantity(String productId, int quantity) async {
    try {
      await _dio.patch<Map<String, dynamic>>(
        '${ApiEndpoints.cart}/$productId',
        data: <String, dynamic>{'quantity': quantity},
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _dio.delete<Map<String, dynamic>>(ApiEndpoints.cart);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  List<dynamic> _extractList(Map<String, dynamic>? data) {
    if (data == null) return [];
    final raw = data['data'] ?? data['items'] ?? data;
    if (raw is List<dynamic>) return raw;
    return [];
  }

  Never _mapDioException(DioException e) {
    final message =
        _messageFromResponse(e.response) ?? e.message ?? 'Request failed';
    if (e.response?.statusCode == 401) throw UnauthorizedException(message);
    if (e.response?.statusCode == 403) throw ForbiddenException(message);
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
