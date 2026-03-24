import 'package:dio/dio.dart';

import '../../../../core/domain/paginated_result.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/order_model.dart';
import 'orders_remote_datasource.dart';

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this._dio);
  final Dio _dio;

  @override
  Future<PaginatedResult<OrderModel>> getOrdersPage({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.orders,
        queryParameters: <String, dynamic>{
          'page': page,
          'per_page': pageSize,
        },
      );
      final list = _extractList(response.data);
      final meta = _extractMeta(response.data);
      final items =
          list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
      return PaginatedResult<OrderModel>(
        items: items,
        currentPage: meta['currentPage'] ?? page,
        totalPages: meta['totalPages'] ?? 1,
        totalCount: meta['totalCount'] ?? items.length,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiEndpoints.orders}/$orderId',
      );
      final map = _extractData(response.data);
      if (map == null) return null;
      return OrderModel.fromJson(map);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw _mapDioException(e);
    }
  }

  List<dynamic> _extractList(Map<String, dynamic>? data) {
    if (data == null) return [];
    final list =
        data['data'] as List<dynamic>? ?? data['items'] as List<dynamic>?;
    return list ?? [];
  }

  Map<String, dynamic>? _extractData(Map<String, dynamic>? data) {
    if (data == null) return null;
    return data['data'] as Map<String, dynamic>? ?? data;
  }

  Map<String, int> _extractMeta(Map<String, dynamic>? data) {
    if (data == null) return <String, int>{};
    final meta = data['meta'] as Map<String, dynamic>? ??
        data['pagination'] as Map<String, dynamic>?;
    if (meta == null) return <String, int>{};
    final current = meta['current_page'] ?? meta['currentPage'] ?? 1;
    final last = meta['last_page'] ?? meta['totalPages'] ?? 1;
    final total = meta['total'] ?? meta['totalCount'] ?? 0;
    return <String, int>{
      'currentPage': (current is num) ? current.toInt() : 1,
      'totalPages': (last is num) ? last.toInt() : 1,
      'totalCount': (total is num) ? total.toInt() : 0,
    };
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
