import '../repositories/cart_repository.dart';

class UpdateCartItemQuantityUseCase {
  UpdateCartItemQuantityUseCase(this._repository);
  final CartRepository _repository;

  Future<void> call(String productId, int quantity) =>
      _repository.updateQuantity(productId, quantity);
}
