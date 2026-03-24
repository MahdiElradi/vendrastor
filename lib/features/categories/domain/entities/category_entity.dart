/// Domain entity for a category.
class CategoryEntity {
  const CategoryEntity({required this.id, required this.name, this.imageUrl});
  final String id;
  final String name;
  final String? imageUrl;
}
