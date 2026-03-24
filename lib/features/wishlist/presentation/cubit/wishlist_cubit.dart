import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/toggle_wishlist_item_usecase.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit({
    required GetWishlistUseCase getWishlistUseCase,
    required ToggleWishlistItemUseCase toggleWishlistItemUseCase,
  })  : _getWishlist = getWishlistUseCase,
        _toggle = toggleWishlistItemUseCase,
        super(const WishlistState());

  final GetWishlistUseCase _getWishlist;
  final ToggleWishlistItemUseCase _toggle;

  Future<void> loadWishlist() async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final list = await _getWishlist();
      emit(state.copyWith(items: list, isLoading: false, failure: null));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        failure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }

  Future<void> toggle(String productId) async {
    try {
      await _toggle(productId);
      await loadWishlist();
    } catch (e) {
      emit(state.copyWith(
        failure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }
}
