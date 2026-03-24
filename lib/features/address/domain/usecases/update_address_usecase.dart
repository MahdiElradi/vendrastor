import '../entities/address_entity.dart';
import '../repositories/address_repository.dart';

class UpdateAddressUseCase {
  UpdateAddressUseCase(this._repository);

  final AddressRepository _repository;

  Future<void> call(AddressEntity address) =>
      _repository.updateAddress(address);
}
