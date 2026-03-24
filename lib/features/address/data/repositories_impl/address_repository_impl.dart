import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {
  AddressRepositoryImpl(this._local);

  final AddressLocalDataSource _local;

  @override
  Future<void> addAddress(AddressEntity address) async {
    final items = await _local.getAddresses();
    final updated = List<Map<String, dynamic>>.from(items)
      ..add(address.toMap());
    await _local.saveAddresses(updated);
  }

  @override
  Future<void> deleteAddress(String id) async {
    final items = await _local.getAddresses();
    final updated = items.where((m) => m['id'] != id).toList();
    await _local.saveAddresses(updated);
  }

  @override
  Future<List<AddressEntity>> getAddresses() async {
    final items = await _local.getAddresses();
    return items.map(AddressEntity.fromMap).toList();
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    final items = await _local.getAddresses();
    final updated = items.map((raw) {
      final m = Map<String, dynamic>.from(raw);
      m['isDefault'] = m['id'] == id;
      return m;
    }).toList();
    await _local.saveAddresses(updated);
  }

  @override
  Future<void> updateAddress(AddressEntity address) async {
    final items = await _local.getAddresses();
    final updated = items.map((raw) {
      final m = Map<String, dynamic>.from(raw);
      if (m['id'] == address.id) {
        return address.toMap();
      }
      return m;
    }).toList();
    await _local.saveAddresses(updated);
  }
}
