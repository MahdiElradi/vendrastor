import '../../../home/domain/entities/product_entity.dart';
import '../../../home/domain/repositories/product_repository.dart';

/// Use case: fetch full product details by id.
class GetProductDetailsUseCase {
  GetProductDetailsUseCase(this._repository);
  final ProductRepository _repository;

  Future<ProductEntity?> call(String productId) =>
      _repository.getProductById(productId);
}
