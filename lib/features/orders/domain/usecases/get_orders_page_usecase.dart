import '../../../../core/domain/paginated_result.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrdersPageUseCase {
  GetOrdersPageUseCase(this._repository);
  final OrdersRepository _repository;

  Future<PaginatedResult<OrderEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) =>
      _repository.getOrdersPage(page: page, pageSize: pageSize);
}
