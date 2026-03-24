import '../../domain/entities/address_entity.dart';

class AddressState {
  const AddressState({
    this.isLoading = false,
    this.addresses = const [],
    this.failureMessage,
  });

  final bool isLoading;
  final List<AddressEntity> addresses;
  final String? failureMessage;

  AddressState copyWith({
    bool? isLoading,
    List<AddressEntity>? addresses,
    String? failureMessage,
  }) {
    return AddressState(
      isLoading: isLoading ?? this.isLoading,
      addresses: addresses ?? this.addresses,
      failureMessage: failureMessage,
    );
  }
}
