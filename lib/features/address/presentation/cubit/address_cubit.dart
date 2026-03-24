import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/usecases/add_address_usecase.dart';
import '../../domain/usecases/delete_address_usecase.dart';
import '../../domain/usecases/get_addresses_usecase.dart';
import '../../domain/usecases/set_default_address_usecase.dart';
import '../../domain/usecases/update_address_usecase.dart';
import 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit(
    this._getAddresses,
    this._addAddress,
    this._updateAddress,
    this._deleteAddress,
    this._setDefaultAddress,
  ) : super(const AddressState());

  final GetAddressesUseCase _getAddresses;
  final AddAddressUseCase _addAddress;
  final UpdateAddressUseCase _updateAddress;
  final DeleteAddressUseCase _deleteAddress;
  final SetDefaultAddressUseCase _setDefaultAddress;

  Future<void> loadAddresses() async {
    emit(state.copyWith(isLoading: true, failureMessage: null));
    try {
      final addresses = await _getAddresses();
      emit(state.copyWith(isLoading: false, addresses: addresses));
    } catch (e) {
      emit(state.copyWith(isLoading: false, failureMessage: e.toString()));
    }
  }

  Future<void> addAddress(AddressEntity address) async {
    try {
      await _addAddress(address);
      await loadAddresses();
    } catch (e) {
      emit(state.copyWith(failureMessage: e.toString()));
    }
  }

  Future<void> updateAddress(AddressEntity address) async {
    try {
      await _updateAddress(address);
      await loadAddresses();
    } catch (e) {
      emit(state.copyWith(failureMessage: e.toString()));
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _deleteAddress(id);
      await loadAddresses();
    } catch (e) {
      emit(state.copyWith(failureMessage: e.toString()));
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      await _setDefaultAddress(id);
      await loadAddresses();
    } catch (e) {
      emit(state.copyWith(failureMessage: e.toString()));
    }
  }
}
