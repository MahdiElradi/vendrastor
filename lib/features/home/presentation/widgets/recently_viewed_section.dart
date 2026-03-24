import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/product_card.dart';
import '../../domain/entities/product_entity.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../recently_viewed/presentation/cubit/recently_viewed_cubit.dart';

/// Shows recently viewed products as a horizontal carousel.
class RecentlyViewedSection extends StatelessWidget {
  const RecentlyViewedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentlyViewedCubit, List<ProductEntity>>(
      builder: (context, recentlyViewed) {
        if (recentlyViewed.isEmpty) return const SizedBox.shrink();

        final wishlistedIds = context.select<WishlistCubit, Set<String>>(
          (cubit) => cubit.state.items.map((product) => product.id).toSet(),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recently viewed',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: recentlyViewed.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final product = recentlyViewed[index];
                    final isWishlisted = wishlistedIds.contains(product.id);
                    return SizedBox(
                      width: 160,
                      child: ProductCard(
                        product: product,
                        isWishlisted: isWishlisted,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.productDetails,
                            arguments: product.id,
                          );
                          context.read<RecentlyViewedCubit>().add(product.id);
                        },
                        onWishlistTap: () =>
                            context.read<WishlistCubit>().toggle(product.id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
