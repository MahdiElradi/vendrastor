import '../../../../core/storage/hive_manager.dart';

/// Simple local datasource for address persistence.
///
/// Stores addresses as a list of maps inside the `settings` Hive box.
class AddressLocalDataSource {
  static const _key = 'addresses';

  Future<List<Map<String, dynamic>>> getAddresses() async {
    final box = HiveManager.settingsBox();
    final raw = box.get(_key) as List<dynamic>?;
    if (raw == null) return [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<void> saveAddresses(List<Map<String, dynamic>> addresses) async {
    final box = HiveManager.settingsBox();
    await box.put(_key, addresses);
  }
}
