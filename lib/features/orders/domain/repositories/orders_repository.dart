import '../../../../core/domain/paginated_result.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<PaginatedResult<OrderEntity>> getOrdersPage({
    int page = 1,
    int pageSize = 20,
  });
  Future<OrderEntity?> getOrderById(String orderId);
}
