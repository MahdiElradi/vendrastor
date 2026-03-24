import '../../../orders/domain/entities/order_entity.dart';

/// Contract for checkout (place order, optional summary).
abstract class CheckoutRepository {
  Future<OrderEntity> placeOrder({String? addressId});
}
