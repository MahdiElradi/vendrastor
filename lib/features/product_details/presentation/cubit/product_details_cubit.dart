import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(this._getProductDetailsUseCase)
      : super(const ProductDetailsState());

  final GetProductDetailsUseCase _getProductDetailsUseCase;

  Future<void> loadProduct(String productId) async {
    if (productId.isEmpty) {
      emit(state.copyWith(
        failure: const ServerFailure('Invalid product'),
      ));
      return;
    }
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final product = await _getProductDetailsUseCase(productId);
      emit(state.copyWith(
        product: product,
        isLoading: false,
        failure: product == null ? const ServerFailure('Product not found') : null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        failure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }
}
