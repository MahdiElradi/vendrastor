import '../../../home/domain/entities/product_entity.dart';
import '../repositories/wishlist_repository.dart';

class GetWishlistUseCase {
  GetWishlistUseCase(this._repository);
  final WishlistRepository _repository;

  Future<List<ProductEntity>> call() => _repository.getWishlist();
}
