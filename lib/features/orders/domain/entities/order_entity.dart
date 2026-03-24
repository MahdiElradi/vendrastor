/// Domain entity for order (reused from checkout where applicable).
class OrderEntity {
  const OrderEntity({
    required this.id,
    required this.status,
    this.total,
    this.createdAt,
  });
  final String id;
  final String status;
  final double? total;
  final DateTime? createdAt;
}
