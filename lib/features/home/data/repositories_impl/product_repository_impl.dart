import '../../../../core/domain/paginated_result.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_datasource.dart';
import '../datasources/product_remote_datasource.dart';

/// Implements ProductRepository with remote and cache.
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  @override
  Future<List<BannerEntity>> getBanners() async {
    try {
      final list = await _remote.getBanners();
      await _local.cacheBanners(list);
      return list;
    } catch (e) {
      final cached = await _local.getCachedBanners();
      if (cached.isNotEmpty) return cached;
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<List<ProductEntity>> getFeaturedProducts() async {
    try {
      final list = await _remote.getFeaturedProducts();
      await _local.cacheProducts(list);
      return list;
    } catch (e) {
      final cached = await _local.getCachedProducts();
      if (cached.isNotEmpty) return cached;
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    try {
      final product = await _remote.getProductById(id);
      if (product != null) await _local.cacheProduct(product);
      return product;
    } catch (e) {
      final cached = await _local.getCachedProductById(id);
      if (cached != null) return cached;
      throw ErrorMapper.fromException(e);
    }
  }

  @override
  Future<PaginatedResult<ProductEntity>> getProductsPage({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
  }) async {
    try {
      return await _remote.getProductsPage(
        page: page,
        pageSize: pageSize,
        categoryId: categoryId,
      );
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }
}
