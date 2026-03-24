import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/product_entity.dart';

class WishlistState {
  const WishlistState({
    this.items = const [],
    this.isLoading = false,
    this.failure,
  });

  final List<ProductEntity> items;
  final bool isLoading;
  final Failure? failure;

  WishlistState copyWith({
    List<ProductEntity>? items,
    bool? isLoading,
    Failure? failure,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}
