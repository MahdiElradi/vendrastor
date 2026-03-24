import 'cart_item_entity.dart';

/// Domain entity for cart (items and totals).
class CartEntity {
  const CartEntity({
    this.items = const [],
    this.total = 0.0,
  });
  final List<CartItemEntity> items;
  final double total;

  int get itemCount =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);
}
