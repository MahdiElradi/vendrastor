import '../models/banner_model.dart';
import '../models/product_model.dart';
import '../../../../core/domain/paginated_result.dart';

/// Remote data source for products and banners (Dio).
abstract class ProductRemoteDataSource {
  Future<List<BannerModel>> getBanners();
  Future<List<ProductModel>> getFeaturedProducts();
  Future<ProductModel?> getProductById(String id);
  Future<PaginatedResult<ProductModel>> getProductsPage({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
  });
}
