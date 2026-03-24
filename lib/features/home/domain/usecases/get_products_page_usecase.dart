import '../../../../core/domain/paginated_result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsPageUseCase {
  GetProductsPageUseCase(this._repository);
  final ProductRepository _repository;

  Future<PaginatedResult<ProductEntity>> call({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
  }) =>
      _repository.getProductsPage(
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
      );
}
