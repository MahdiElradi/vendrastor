import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  GetCartUseCase(this._repository);
  final CartRepository _repository;

  Future<CartEntity> call() => _repository.getCart();
}
