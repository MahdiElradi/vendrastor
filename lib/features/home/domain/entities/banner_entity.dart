/// Domain entity for a home banner.
class BannerEntity {
  const BannerEntity({
    required this.id,
    required this.imageUrl,
    this.title,
    this.linkUrl,
  });
  final String id;
  final String imageUrl;
  final String? title;
  final String? linkUrl;
}
