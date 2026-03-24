import '../entities/address_entity.dart';
import '../repositories/address_repository.dart';

class GetAddressesUseCase {
  GetAddressesUseCase(this._repository);

  final AddressRepository _repository;

  Future<List<AddressEntity>> call() => _repository.getAddresses();
}
