import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderDetailsUseCase {
  GetOrderDetailsUseCase(this._repository);
  final OrdersRepository _repository;

  Future<OrderEntity?> call(String orderId) =>
      _repository.getOrderById(orderId);
}
