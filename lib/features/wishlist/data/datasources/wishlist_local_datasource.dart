import '../../../home/data/models/product_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<String>> getWishlistIds();
  Future<void> addId(String productId);
  Future<void> removeId(String productId);
  Future<void> setProducts(List<ProductModel> products);
  Future<List<ProductModel>> getCachedProducts();
}
