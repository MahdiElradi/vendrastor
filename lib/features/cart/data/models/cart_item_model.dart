import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.title,
    required super.price,
    required super.quantity,
    super.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id']?.toString() ?? json['productId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'product_id': productId,
        'title': title,
        'price': price,
        'quantity': quantity,
        'image_url': imageUrl,
      };
}
