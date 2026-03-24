import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../orders/data/models/order_model.dart';
import 'checkout_remote_datasource.dart';

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  CheckoutRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<OrderModel> placeOrder({String? addressId}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.checkout,
        data: <String, dynamic>{if (addressId != null) 'address_id': addressId},
      );
      final data = response.data;
      final map =
          data?['data'] as Map<String, dynamic>? ??
          data;
      if (map == null) throw const ServerException('Invalid response');
      return OrderModel.fromJson(map);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
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
