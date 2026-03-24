import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/asset_or_network_image.dart';
import '../../../../core/widgets/loading_spinner.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../../home/domain/usecases/get_featured_products_usecase.dart';
import '../../../recently_viewed/presentation/cubit/recently_viewed_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/product_details_state.dart';

/// Product details: images, price, add to cart/wishlist.
class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, this.productId});

  final String? productId;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? _loadedProductId;
  late final Future<List<ProductEntity>> _relatedProductsFuture;

  @override
  void initState() {
    super.initState();
    _relatedProductsFuture = sl<GetFeaturedProductsUseCase>()();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id =
        widget.productId ??
        (ModalRoute.of(context)?.settings.arguments as String?);
    if (id != null && id.isNotEmpty && id != _loadedProductId) {
      _loadedProductId = id;
      context.read<ProductDetailsCubit>().loadProduct(id);
      // Track recently viewed products across the app.
      context.read<RecentlyViewedCubit>().add(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product'),
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, wishlistState) {
              final productId =
                  widget.productId ??
                  (ModalRoute.of(context)?.settings.arguments as String?);
              final isWishlisted =
                  productId != null &&
                  wishlistState.items.any((p) => p.id == productId);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: productId == null
                    ? null
                    : () => context.read<WishlistCubit>().toggle(productId),
                tooltip: isWishlisted
                    ? 'Remove from wishlist'
                    : 'Add to wishlist',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state.isLoading && state.product == null) {
            return const LoadingSpinner();
          }
          if (state.failure != null && state.product == null) {
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
                      onPressed: () => Navigator.maybePop(context),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            );
          }
          final product = state.product;
          if (product == null) {
            return const Center(child: Text('Product not found'));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 1,
                    child: AssetOrNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 64),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.priceAfterDiscount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (product.discountPercent != null &&
                              product.discountPercent! > 0) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                          const Spacer(),
                          BlocBuilder<WishlistCubit, WishlistState>(
                            builder: (context, wishlistState) {
                              final productId =
                                  widget.productId ??
                                  (ModalRoute.of(context)?.settings.arguments
                                      as String?);
                              final isWishlisted =
                                  productId != null &&
                                  wishlistState.items.any(
                                    (p) => p.id == productId,
                                  );
                              return IconButton(
                                iconSize: 28,
                                icon: Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color: Theme.of(context).colorScheme.primary,
                                onPressed: productId == null
                                    ? null
                                    : () => context
                                          .read<WishlistCubit>()
                                          .toggle(productId),
                              );
                            },
                          ),
                        ],
                      ),
                      if (product.description != null &&
                          product.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          product.description!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            context.read<CartCubit>().addToCart(product.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'Related products',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      FutureBuilder<List<ProductEntity>>(
                        future: _relatedProductsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return SizedBox(
                              height: 190,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.sm,
                                ),
                                itemCount: 3,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: AppSpacing.sm),
                                itemBuilder: (context, index) => const SizedBox(
                                  width: 160,
                                  child: SkeletonBox(height: 180),
                                ),
                              ),
                            );
                          }
                          final related = (snapshot.data ?? [])
                              .where((p) => p.id != product.id)
                              .toList();
                          if (related.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                              ),
                              child: Text(
                                'No related products available.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }
                          return SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.sm,
                              ),
                              itemCount: related.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: AppSpacing.sm),
                              itemBuilder: (context, index) {
                                final relatedProduct = related[index];
                                return SizedBox(
                                  width: 160,
                                  child: ProductCard(
                                    product: relatedProduct,
                                    isWishlisted: false,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.productDetails,
                                      arguments: relatedProduct.id,
                                    ),
                                    onWishlistTap: () => context
                                        .read<WishlistCubit>()
                                        .toggle(relatedProduct.id),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
