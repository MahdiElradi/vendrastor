import '../../domain/repositories/recently_viewed_repository.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/domain/repositories/product_repository.dart';
import '../datasources/recently_viewed_local_datasource.dart';

class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  RecentlyViewedRepositoryImpl(this._local, this._productRepository);

  final RecentlyViewedLocalDataSource _local;
  final ProductRepository _productRepository;

  @override
  Future<List<String>> getRecentlyViewedIds() async {
    return _local.getRecentlyViewedIds();
  }

  @override
  Future<void> addRecentlyViewed(String productId) async {
    final ids = await _local.getRecentlyViewedIds();
    final updated = [productId, ...ids.where((id) => id != productId)];
    // Keep last 12
    await _local.saveRecentlyViewedIds(updated.take(12).toList());
  }

  Future<List<ProductEntity>> getRecentlyViewedProducts() async {
    final ids = await getRecentlyViewedIds();
    final products = <ProductEntity>[];
    for (final id in ids) {
      final product = await _productRepository.getProductById(id);
      if (product != null) {
        products.add(product);
      }
    }
    return products;
  }
}
