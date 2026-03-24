import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_entity.dart';

class CartState {
  const CartState({
    this.cart = const CartEntity(),
    this.isLoading = false,
    this.failure,
  });

  final CartEntity cart;
  final bool isLoading;
  final Failure? failure;

  CartState copyWith({
    CartEntity? cart,
    bool? isLoading,
    Failure? failure,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}
