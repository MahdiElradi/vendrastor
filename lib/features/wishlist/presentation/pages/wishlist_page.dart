import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../../core/widgets/product_card.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

/// Wishlist items; move to cart, remove.
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key, this.useScaffold = true});

  final bool useScaffold;

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    final body = BlocBuilder<WishlistCubit, WishlistState>(
      builder: (context, state) {
        if (state.isLoading && state.items.isEmpty) {
          return _buildLoadingSkeleton();
        }
        if (state.failure != null && state.items.isEmpty) {
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
                        context.read<WishlistCubit>().loadWishlist(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (state.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Your wishlist is empty',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: () => Navigator.pushNamed(context, AppRouter.home),
                  child: const Text('Browse products'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () => context.read<WishlistCubit>().loadWishlist(),
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final product = state.items[index];
              return ProductCard(
                product: product,
                isWishlisted: true,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouter.productDetails,
                  arguments: product.id,
                ),
                onWishlistTap: () =>
                    context.read<WishlistCubit>().toggle(product.id),
              );
            },
          ),
        );
      },
    );

    return widget.useScaffold
        ? Scaffold(
            appBar: AppBar(title: const Text('Wishlist')),
            body: body,
          )
        : body;
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              SkeletonBox(height: 170),
              SizedBox(height: AppSpacing.sm),
              SkeletonBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
