import '../../../../core/domain/paginated_result.dart';
import '../entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';

/// Contract for categories and category products.
abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<PaginatedResult<ProductEntity>> getCategoryProducts(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  });
}
