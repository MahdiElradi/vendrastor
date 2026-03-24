import '../models/cart_item_model.dart';

/// Local cart cache (Hive).
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clear();
}
