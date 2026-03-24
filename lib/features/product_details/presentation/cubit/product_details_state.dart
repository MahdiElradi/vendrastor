import '../../../../core/error/failures.dart';
import '../../../home/domain/entities/product_entity.dart';

class ProductDetailsState {
  const ProductDetailsState({
    this.product,
    this.isLoading = false,
    this.failure,
  });

  final ProductEntity? product;
  final bool isLoading;
  final Failure? failure;

  ProductDetailsState copyWith({
    ProductEntity? product,
    bool? isLoading,
    Failure? failure,
  }) {
    return ProductDetailsState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      failure: failure ?? this.failure,
    );
  }
}
