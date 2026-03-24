/// A single line item in the cart.
class CartItemEntity {
  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String? imageUrl;

  double get subtotal => price * quantity;
}
