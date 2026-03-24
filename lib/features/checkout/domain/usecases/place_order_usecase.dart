import '../../../orders/domain/entities/order_entity.dart';
import '../repositories/checkout_repository.dart';

class PlaceOrderUseCase {
  PlaceOrderUseCase(this._repository);
  final CheckoutRepository _repository;

  Future<OrderEntity> call({String? addressId}) =>
      _repository.placeOrder(addressId: addressId);
}
