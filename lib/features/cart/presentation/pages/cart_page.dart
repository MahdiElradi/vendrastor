import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/asset_or_network_image.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Cart list, quantities, summary, navigate to checkout.
class CartPage extends StatefulWidget {
  const CartPage({super.key, this.useScaffold = true});

  final bool useScaffold;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.isLoading && state.cart.items.isEmpty) {
          return _buildLoadingSkeleton(context);
        }
        if (state.failure != null && state.cart.items.isEmpty) {
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
                    onPressed: () => context.read<CartCubit>().loadCart(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.cart.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Your cart is empty',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.home,
                    (route) => false,
                  ),
                  child: const Text('Browse products'),
                ),
              ],
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.cart.items.length,
                itemBuilder: (context, index) {
                  final item = state.cart.items[index];
                  return _CartItemTile(
                    item: item,
                    onRemove: () => context.read<CartCubit>().removeFromCart(
                      item.productId,
                    ),
                    onQuantityChanged: (q) => context
                        .read<CartCubit>()
                        .updateQuantity(item.productId, q),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '\$${state.cart.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRouter.checkout),
                        child: const Text('Proceed to Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    return widget.useScaffold
        ? Scaffold(
            appBar: AppBar(title: const Text('Cart')),
            body: body,
          )
        : body;
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          ...List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: const [
                  SkeletonBox(width: 72, height: 72),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(height: 18, width: double.infinity),
                        SizedBox(height: AppSpacing.xs),
                        SkeletonBox(height: 14, width: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                SkeletonBox(height: 20, width: double.infinity),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 44, width: double.infinity),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  final CartItemEntity item;
  final VoidCallback onRemove;
  final void Function(int) onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AssetOrNetworkImage(
                  imageUrl: item.imageUrl!,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 72,
                    height: 72,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              )
            else
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined),
              ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${item.price.toStringAsFixed(2)} × ${item.quantity}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: item.quantity > 1
                            ? () => onQuantityChanged(item.quantity - 1)
                            : null,
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => onQuantityChanged(item.quantity + 1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '\$${item.subtotal.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
