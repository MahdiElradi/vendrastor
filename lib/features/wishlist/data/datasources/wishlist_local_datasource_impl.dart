import 'dart:convert';

import '../../../../core/storage/hive_manager.dart';
import '../../../home/data/models/product_model.dart';
import 'wishlist_local_datasource.dart';

class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  static const String _idsKey = 'ids';
  static const String _productsKey = 'products';

  @override
  Future<List<String>> getWishlistIds() async {
    final box = HiveManager.box<dynamic>(HiveBox.wishlist);
    final jsonStr = box.get(_idsKey) as String?;
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> addId(String productId) async {
    final ids = await getWishlistIds();
    if (ids.contains(productId)) return;
    ids.add(productId);
    final box = HiveManager.box<dynamic>(HiveBox.wishlist);
    await box.put(_idsKey, jsonEncode(ids));
  }

  @override
  Future<void> removeId(String productId) async {
    final ids = await getWishlistIds();
    ids.remove(productId);
    final box = HiveManager.box<dynamic>(HiveBox.wishlist);
    await box.put(_idsKey, jsonEncode(ids));
  }

  @override
  Future<void> setProducts(List<ProductModel> products) async {
    final box = HiveManager.box<dynamic>(HiveBox.wishlist);
    final list = products.map((p) => _productToJson(p)).toList();
    await box.put(_productsKey, jsonEncode(list));
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    final box = HiveManager.box<dynamic>(HiveBox.wishlist);
    final jsonStr = box.get(_productsKey) as String?;
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> _productToJson(ProductModel p) => <String, dynamic>{
        'id': p.id,
        'title': p.title,
        'price': p.price,
        'image_url': p.imageUrl,
        'description': p.description,
        'rating': p.rating,
        'discount_percent': p.discountPercent,
        'category_id': p.categoryId,
      };
}
