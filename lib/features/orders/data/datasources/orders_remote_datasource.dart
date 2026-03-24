import '../../../../core/domain/paginated_result.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<PaginatedResult<OrderModel>> getOrdersPage({
    int page = 1,
    int pageSize = 20,
  });
  Future<OrderModel?> getOrderById(String orderId);
}
