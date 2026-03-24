import '../models/banner_model.dart';
import '../models/product_model.dart';

/// Local cache for products and banners (e.g. Hive).
abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getCachedProducts();
  Future<List<BannerModel>> getCachedBanners();
  Future<ProductModel?> getCachedProductById(String id);
  Future<void> cacheProducts(List<ProductModel> products);
  Future<void> cacheBanners(List<BannerModel> banners);
  Future<void> cacheProduct(ProductModel product);
}
