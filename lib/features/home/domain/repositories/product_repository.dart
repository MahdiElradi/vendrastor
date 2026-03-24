import '../../../../core/domain/paginated_result.dart';
import '../entities/banner_entity.dart';
import '../entities/product_entity.dart';

/// Contract for products, banners, and paginated lists.
abstract class ProductRepository {
  Future<List<BannerEntity>> getBanners();
  Future<List<ProductEntity>> getFeaturedProducts();
  Future<ProductEntity?> getProductById(String id);
  Future<PaginatedResult<ProductEntity>> getProductsPage({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
  });
}
