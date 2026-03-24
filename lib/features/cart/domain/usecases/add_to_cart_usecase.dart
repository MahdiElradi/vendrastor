import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  AddToCartUseCase(this._repository);
  final CartRepository _repository;

  Future<void> call(String productId, {int quantity = 1}) =>
      _repository.addToCart(productId, quantity: quantity);
}
