import '../../domain/entities/banner_entity.dart';

/// DTO for banner from API.
class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.imageUrl,
    super.title,
    super.linkUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      title: json['title'] as String?,
      linkUrl: json['link_url'] as String? ?? json['linkUrl'] as String?,
    );
  }
}
