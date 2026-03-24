import '../../domain/entities/product_entity.dart';

/// DTO for product from API.
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.price,
    super.imageUrl,
    super.description,
    super.rating,
    super.discountPercent,
    super.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      description: json['description'] as String? ?? json['desc'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble() ??
          (json['discountPercent'] as num?)?.toDouble(),
      categoryId: json['category_id'] as String? ?? json['categoryId'] as String?,
    );
  }
}
