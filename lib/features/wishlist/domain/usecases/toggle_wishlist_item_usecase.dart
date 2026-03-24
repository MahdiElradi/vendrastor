import '../repositories/wishlist_repository.dart';

class ToggleWishlistItemUseCase {
  ToggleWishlistItemUseCase(this._repository);
  final WishlistRepository _repository;

  Future<void> call(String productId) => _repository.toggle(productId);
}
