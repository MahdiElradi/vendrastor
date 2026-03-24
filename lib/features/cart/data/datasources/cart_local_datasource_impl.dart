import 'dart:convert';

import '../../../../core/storage/hive_manager.dart';
import '../models/cart_item_model.dart';
import 'cart_local_datasource.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String _key = 'items';

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final box = HiveManager.box<dynamic>(HiveBox.cart);
    final jsonStr = box.get(_key) as String?;
    if (jsonStr == null) return [];
    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final box = HiveManager.box<dynamic>(HiveBox.cart);
    final list = items.map((e) => e.toJson()).toList();
    await box.put(_key, jsonEncode(list));
  }

  @override
  Future<void> clear() async {
    final box = HiveManager.box<dynamic>(HiveBox.cart);
    await box.delete(_key);
  }
}
