import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';

class OrdersState {
  const OrdersState({
    this.orders = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.failure,
    this.loadMoreFailure,
  });

  final List<OrderEntity> orders;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final Failure? failure;
  final Failure? loadMoreFailure;

  OrdersState copyWith({
    List<OrderEntity>? orders,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    Failure? failure,
    Failure? loadMoreFailure,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure ?? this.failure,
      loadMoreFailure: loadMoreFailure ?? this.loadMoreFailure,
    );
  }
}
