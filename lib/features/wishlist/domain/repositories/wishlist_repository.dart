import '../../../home/domain/entities/product_entity.dart';

/// Contract for wishlist (toggle, get list).
abstract class WishlistRepository {
  Future<void> toggle(String productId);
  Future<List<ProductEntity>> getWishlist();
}
