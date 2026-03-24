import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/widgets/loading_spinner.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

/// Orders list with pagination.
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<OrdersCubit>().loadOrders();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<OrdersCubit>();
    final state = cubit.state;
    if (!state.hasMore || state.isLoadingMore) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.isLoading && state.orders.isEmpty) {
            return const LoadingSpinner();
          }
          if (state.failure != null && state.orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.failure!.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton(
                      onPressed: () =>
                          context.read<OrdersCubit>().loadOrders(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No orders yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<OrdersCubit>().loadOrders(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.orders.length +
                  (state.isLoadingMore ? 1 : 0) +
                  (state.loadMoreFailure != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= state.orders.length) {
                  if (state.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Center(
                      child: Text(
                        state.loadMoreFailure!.message,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                      ),
                    ),
                  );
                }
                final order = state.orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Text(
                      order.status,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: order.total != null
                        ? Text(
                            '\$${order.total!.toStringAsFixed(2)}',
                            style:
                                Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          )
                        : null,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
