import '../../domain/entities/category_entity.dart';

/// DTO for category from API.
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    super.imageUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
    );
  }
}
