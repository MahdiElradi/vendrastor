import '../../../orders/data/models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<OrderModel> placeOrder({String? addressId});
}
