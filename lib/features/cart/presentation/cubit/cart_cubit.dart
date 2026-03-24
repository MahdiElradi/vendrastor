import 'package:vendrastor_app/features/cart/domain/entities/cart_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_quantity_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required GetCartUseCase getCartUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required UpdateCartItemQuantityUseCase updateQuantityUseCase,
    required ClearCartUseCase clearCartUseCase,
  }) : _getCart = getCartUseCase,
       _addToCart = addToCartUseCase,
       _removeFromCart = removeFromCartUseCase,
       _updateQuantity = updateQuantityUseCase,
       _clearCart = clearCartUseCase,
       super(const CartState());

  final GetCartUseCase _getCart;
  final AddToCartUseCase _addToCart;
  final RemoveFromCartUseCase _removeFromCart;
  final UpdateCartItemQuantityUseCase _updateQuantity;
  final ClearCartUseCase _clearCart;

  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final cart = await _getCart();
      emit(state.copyWith(cart: cart, isLoading: false, failure: null));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          failure: e is Failure ? e : ErrorMapper.fromException(e),
        ),
      );
    }
  }

  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      await _addToCart(productId, quantity: quantity);
      await loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          failure: e is Failure ? e : ErrorMapper.fromException(e),
        ),
      );
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _removeFromCart(productId);
      await loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          failure: e is Failure ? e : ErrorMapper.fromException(e),
        ),
      );
    }
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      await _updateQuantity(productId, quantity);
      await loadCart();
    } catch (e) {
      emit(
        state.copyWith(
          failure: e is Failure ? e : ErrorMapper.fromException(e),
        ),
      );
    }
  }

  Future<void> clearCart() async {
    try {
      await _clearCart();
      emit(state.copyWith(cart: const CartEntity(), failure: null));
    } catch (e) {
      emit(
        state.copyWith(
          failure: e is Failure ? e : ErrorMapper.fromException(e),
        ),
      );
    }
  }
}
