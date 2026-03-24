import '../../../../core/error/error_mapper.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_remote_datasource.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  CheckoutRepositoryImpl(this._remote);
  final CheckoutRemoteDataSource _remote;

  @override
  Future<OrderEntity> placeOrder({String? addressId}) async {
    try {
      return await _remote.placeOrder(addressId: addressId);
    } catch (e) {
      throw ErrorMapper.fromException(e);
    }
  }
}
