import 'dart:convert';

import '../../../../core/storage/hive_manager.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../models/banner_model.dart';
import '../models/product_model.dart';
import 'product_local_datasource.dart';

/// Hive-based cache for products and banners.
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String _productsKey = 'list';
  static const String _bannersKey = 'list';
  static const String _productPrefix = 'product_';

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final box = HiveManager.box<dynamic>(HiveBox.products);
    final jsonStr = box.get(_productsKey) as String?;
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<BannerModel>> getCachedBanners() async {
    final box = HiveManager.box<dynamic>(HiveBox.banners);
    final jsonStr = box.get(_bannersKey) as String?;
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => BannerModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<ProductModel?> getCachedProductById(String id) async {
    final box = HiveManager.box<dynamic>(HiveBox.products);
    final jsonStr = box.get(_productPrefix + id) as String?;
    if (jsonStr == null) return null;
    try {
      return ProductModel.fromJson(jsonDecode(jsonStr) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = HiveManager.box<dynamic>(HiveBox.products);
    final list = products.map((e) => _productToJson(e)).toList();
    await box.put(_productsKey, jsonEncode(list));
  }

  @override
  Future<void> cacheBanners(List<BannerModel> banners) async {
    final box = HiveManager.box<dynamic>(HiveBox.banners);
    final list = banners.map((e) => _bannerToJson(e)).toList();
    await box.put(_bannersKey, jsonEncode(list));
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    final box = HiveManager.box<dynamic>(HiveBox.products);
    await box.put(_productPrefix + product.id, jsonEncode(_productToJson(product)));
  }

  Map<String, dynamic> _productToJson(ProductEntity p) => <String, dynamic>{
        'id': p.id,
        'title': p.title,
        'price': p.price,
        'image_url': p.imageUrl,
        'description': p.description,
        'rating': p.rating,
        'discount_percent': p.discountPercent,
        'category_id': p.categoryId,
      };

  Map<String, dynamic> _bannerToJson(BannerEntity b) => <String, dynamic>{
        'id': b.id,
        'image_url': b.imageUrl,
        'title': b.title,
        'link_url': b.linkUrl,
      };
}
