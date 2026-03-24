import '../models/cart_item_model.dart';

/// Remote cart API (if backend supports cart).
abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addItem(String productId, int quantity);
  Future<void> removeItem(String productId);
  Future<void> updateItemQuantity(String productId, int quantity);
  Future<void> clear();
}
