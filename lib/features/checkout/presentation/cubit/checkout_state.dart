import '../../../../core/error/failures.dart';
import '../../../orders/domain/entities/order_entity.dart';

class CheckoutState {
  const CheckoutState({
    this.isPlacing = false,
    this.placedOrder,
    this.failure,
  });

  final bool isPlacing;
  final OrderEntity? placedOrder;
  final Failure? failure;

  CheckoutState copyWith({
    bool? isPlacing,
    OrderEntity? placedOrder,
    Failure? failure,
  }) {
    return CheckoutState(
      isPlacing: isPlacing ?? this.isPlacing,
      placedOrder: placedOrder ?? this.placedOrder,
      failure: failure ?? this.failure,
    );
  }
}
