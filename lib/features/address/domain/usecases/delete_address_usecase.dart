import '../repositories/address_repository.dart';

class DeleteAddressUseCase {
  DeleteAddressUseCase(this._repository);

  final AddressRepository _repository;

  Future<void> call(String id) => _repository.deleteAddress(id);
}
