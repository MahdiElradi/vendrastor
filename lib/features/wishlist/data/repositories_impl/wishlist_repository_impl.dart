import '../../../../core/error/error_mapper.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_datasource.dart';
import '../datasources/wishlist_remote_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl({
    required WishlistRemoteDataSource remote,
    required WishlistLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final WishlistRemoteDataSource _remote;
  final WishlistLocalDataSource _local;

  @override
  Future<void> toggle(String productId) async {
    try {
      final ids = await _local.getWishlistIds();
      if (ids.contains(productId)) {
        await _remote.remove(productId);
        await _local.removeId(productId);
      } else {
        await _remote.add(productId);
        await _local.addId(productId);
      }
    } catch (e) {
      final ids = await _local.getWishlistIds();
      if (ids.contains(productId)) {
        await _local.removeId(productId);
      } else {
        await _local.addId(productId);
      }
    }
  }

  @override
  Future<List<ProductEntity>> getWishlist() async {
    try {
      final list = await _remote.getWishlist();
      await _local.setProducts(list);
      return list;
    } catch (e) {
      final cached = await _local.getCachedProducts();
      if (cached.isNotEmpty) return cached;
      throw ErrorMapper.fromException(e);
    }
  }
}
