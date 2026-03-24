import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/product_entity.dart';
import '../../../product_details/domain/usecases/get_product_details_usecase.dart';
import '../../domain/usecases/add_recently_viewed_usecase.dart';
import '../../domain/usecases/get_recently_viewed_usecase.dart';

class RecentlyViewedCubit extends Cubit<List<ProductEntity>> {
  RecentlyViewedCubit({
    required GetRecentlyViewedUseCase getRecentlyViewedUseCase,
    required AddRecentlyViewedUseCase addRecentlyViewedUseCase,
    required GetProductDetailsUseCase getProductDetailsUseCase,
  }) : _getRecently = getRecentlyViewedUseCase,
       _addRecently = addRecentlyViewedUseCase,
       _getProduct = getProductDetailsUseCase,
       super(const []);

  final GetRecentlyViewedUseCase _getRecently;
  final AddRecentlyViewedUseCase _addRecently;
  final GetProductDetailsUseCase _getProduct;

  Future<void> load() async {
    final ids = await _getRecently();
    if (ids.isEmpty) {
      emit(const []);
      return;
    }

    final results = await Future.wait(ids.map((id) => _getProduct(id)));
    final items = results.whereType<ProductEntity>().toList();
    emit(items);
  }

  Future<void> add(String productId) async {
    await _addRecently(productId);

    final existing = state.where((p) => p.id != productId).toList();
    final newlyViewed = await _getProduct(productId);
    if (newlyViewed == null) return;

    final updated = [newlyViewed, ...existing].take(12).toList();
    emit(updated);
  }
}
