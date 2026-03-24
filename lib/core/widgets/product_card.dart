import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import 'asset_or_network_image.dart';
import 'shimmer_loading.dart';
import '../../features/home/domain/entities/product_entity.dart';

/// Reusable product card for grids and lists.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.isWishlisted = false,
    this.onTap,
    this.onWishlistTap,
    this.onAddToCart,
  });

  final ProductEntity product;
  final VoidCallback? onTap;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? AssetOrNetworkImage(
                            imageUrl: product.imageUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SkeletonBox();
                            },
                            errorBuilder: (_, __, ___) => _placeholder(context),
                          )
                        : _placeholder(context),
                  ),
                  if (product.discountPercent != null &&
                      product.discountPercent! > 0)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '-${product.discountPercent!.toInt()}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onError,
                          ),
                        ),
                      ),
                    ),
                  if (onWishlistTap != null)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: IconButton(
                        icon: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_border,
                          color: isWishlisted
                              ? theme.colorScheme.error
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: onWishlistTap,
                        style: IconButton.styleFrom(
                          backgroundColor: theme.colorScheme.surface,
                          padding: const EdgeInsets.all(AppSpacing.xs),
                        ),
                      ),
                    ),
                  if (onAddToCart != null)
                    Positioned(
                      bottom: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: FilledButton(
                        onPressed: onAddToCart,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.add_shopping_cart, size: 18),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${product.priceAfterDiscount.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        if (product.rating != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 14,
                                color: theme.colorScheme.tertiary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                product.rating!.toStringAsFixed(1),
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, size: 48),
      ),
    );
  }
}
