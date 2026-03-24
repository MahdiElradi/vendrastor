import '../repositories/address_repository.dart';

class SetDefaultAddressUseCase {
  SetDefaultAddressUseCase(this._repository);

  final AddressRepository _repository;

  Future<void> call(String id) => _repository.setDefaultAddress(id);
}
