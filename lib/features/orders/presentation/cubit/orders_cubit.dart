import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/get_orders_page_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._getOrdersPageUseCase) : super(const OrdersState());

  final GetOrdersPageUseCase _getOrdersPageUseCase;

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true, failure: null));
    try {
      final result = await _getOrdersPageUseCase(page: 1, pageSize: 20);
      emit(state.copyWith(
        orders: result.items,
        currentPage: result.currentPage,
        hasMore: result.hasMore,
        isLoading: false,
        failure: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        failure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    try {
      final result =
          await _getOrdersPageUseCase(page: state.currentPage + 1, pageSize: 20);
      emit(state.copyWith(
        orders: [...state.orders, ...result.items],
        currentPage: result.currentPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
        loadMoreFailure: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        loadMoreFailure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }
}
