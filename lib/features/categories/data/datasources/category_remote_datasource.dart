import '../../../../core/domain/paginated_result.dart';
import '../../../home/data/models/product_model.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<PaginatedResult<ProductModel>> getCategoryProducts(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  });
}
