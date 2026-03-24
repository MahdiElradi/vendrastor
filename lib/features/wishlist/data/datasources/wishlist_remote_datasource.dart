import '../../../home/data/models/product_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<ProductModel>> getWishlist();
  Future<void> add(String productId);
  Future<void> remove(String productId);
}
