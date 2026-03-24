import '../../../../core/storage/hive_manager.dart';

class RecentlyViewedLocalDataSource {
  static const _key = 'recently_viewed';

  Future<List<String>> getRecentlyViewedIds() async {
    final box = HiveManager.settingsBox();
    final raw = box.get(_key);
    if (raw == null) return [];
    return raw.whereType<String>().toList();
  }

  Future<void> saveRecentlyViewedIds(List<String> ids) async {
    final box = HiveManager.settingsBox();
    await box.put(_key, ids);
  }
}
