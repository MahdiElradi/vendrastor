/// Domain entity for a product.
class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    this.imageUrl,
    this.description,
    this.rating,
    this.discountPercent,
    this.categoryId,
  });
  final String id;
  final String title;
  final double price;
  final String? imageUrl;
  final String? description;
  final double? rating;
  final double? discountPercent;
  final String? categoryId;

  double get priceAfterDiscount {
    if (discountPercent == null || discountPercent! <= 0) return price;
    return price * (1 - discountPercent! / 100);
  }
}
