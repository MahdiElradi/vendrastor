import '../../../../core/domain/paginated_result.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryProductsUseCase {
  GetCategoryProductsUseCase(this._repository);
  final CategoryRepository _repository;

  Future<PaginatedResult<ProductEntity>> call(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  }) =>
      _repository.getCategoryProducts(categoryId, page: page, pageSize: pageSize);
}
