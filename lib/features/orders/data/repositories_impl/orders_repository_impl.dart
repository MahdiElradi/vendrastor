import '../../../../core/domain/paginated_result.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remote);
  final OrdersRemoteDataSource _remote;

  @override
  Future<PaginatedResult<OrderEntity>> getOrdersPage({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await _remote.getOrdersPage(page: page, pageSize: pageSize);
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<OrderEntity?> getOrderById(String orderId) async {
    try {
      return await _remote.getOrderById(orderId);
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }
}
