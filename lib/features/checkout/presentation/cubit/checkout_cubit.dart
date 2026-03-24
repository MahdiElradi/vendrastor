import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/place_order_usecase.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(this._placeOrderUseCase) : super(const CheckoutState());

  final PlaceOrderUseCase _placeOrderUseCase;

  Future<void> placeOrder({String? addressId}) async {
    emit(state.copyWith(isPlacing: true, failure: null));
    try {
      final order = await _placeOrderUseCase(addressId: addressId);
      emit(state.copyWith(
        isPlacing: false,
        placedOrder: order,
        failure: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isPlacing: false,
        failure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }
}
