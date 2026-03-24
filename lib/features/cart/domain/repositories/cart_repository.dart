import '../entities/cart_entity.dart';

/// Contract for cart operations.
abstract class CartRepository {
  Future<CartEntity> getCart();
  Future<void> addToCart(String productId, {int quantity = 1});
  Future<void> removeFromCart(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clearCart();
}
