import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.status,
    super.total,
    super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      status: json['status'] as String? ?? 'pending',
      total: (json['total'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'] as String)
              : null),
    );
  }
}
