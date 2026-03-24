import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../datasources/cart_remote_datasource.dart';
import '../models/cart_item_model.dart';

/// Cart repository: tries remote first, falls back to local and syncs.
class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({
    required CartRemoteDataSource remote,
    required CartLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final CartRemoteDataSource _remote;
  final CartLocalDataSource _local;

  @override
  Future<CartEntity> getCart() async {
    try {
      final items = await _remote.getCartItems();
      await _local.saveCartItems(items);
      return _toCart(items);
    } catch (e) {
      final localItems = await _local.getCartItems();
      return _toCart(localItems);
    }
  }

  @override
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      await _remote.addItem(productId, quantity);
    } catch (_) {
      final items = await _local.getCartItems();
      final idx = items.indexWhere((i) => i.productId == productId);
      if (idx >= 0) {
        final updated = CartItemModel(
          productId: items[idx].productId,
          title: items[idx].title,
          price: items[idx].price,
          quantity: items[idx].quantity + quantity,
          imageUrl: items[idx].imageUrl,
        );
        final newList = [...items]..[idx] = updated;
        await _local.saveCartItems(newList);
      } else {
        final newItem = CartItemModel(
          productId: productId,
          title: 'Product $productId',
          price: 0,
          quantity: quantity,
        );
        await _local.saveCartItems([...items, newItem]);
      }
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    try {
      await _remote.removeItem(productId);
    } catch (e) {
      final items = await _local.getCartItems();
      final newList = items.where((i) => i.productId != productId).toList();
      await _local.saveCartItems(newList);
    }
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(productId);
      return;
    }
    try {
      await _remote.updateItemQuantity(productId, quantity);
    } catch (e) {
      final items = await _local.getCartItems();
      final idx = items.indexWhere((i) => i.productId == productId);
      if (idx >= 0) {
        final updated = CartItemModel(
          productId: items[idx].productId,
          title: items[idx].title,
          price: items[idx].price,
          quantity: quantity,
          imageUrl: items[idx].imageUrl,
        );
        final newList = [...items]..[idx] = updated;
        await _local.saveCartItems(newList);
      }
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await _remote.clear();
    } catch (_) {}
    await _local.clear();
  }

  CartEntity _toCart(List<CartItemModel> items) {
    final entityItems = items
        .map(
          (m) => CartItemEntity(
            productId: m.productId,
            title: m.title,
            price: m.price,
            quantity: m.quantity,
            imageUrl: m.imageUrl,
          ),
        )
        .toList();
    final total =
        entityItems.fold<double>(0, (sum, item) => sum + item.subtotal);
    return CartEntity(items: entityItems, total: total);
  }
}
