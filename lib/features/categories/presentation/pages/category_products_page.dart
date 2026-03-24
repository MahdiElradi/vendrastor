import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/loading_spinner.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../../domain/entities/category_entity.dart';

/// Displays products for a selected category.
class CategoryProductsPage extends StatefulWidget {
  const CategoryProductsPage({super.key, required this.category});

  final CategoryEntity category;

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure that products for this category are loaded when entering.
    context.read<CategoriesCubit>().selectCategory(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        leading: BackButton(
          onPressed: () {
            // Reset selection so the categories grid is clean when returning.
            context.read<CategoriesCubit>().selectCategory(null);
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, wishlistState) {
          final wishlistedIds = wishlistState.items
              .map((product) => product.id)
              .toSet();
          return BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state.isLoadingProducts && state.products.isEmpty) {
                return const LoadingSpinner();
              }
              if (state.productsFailure != null && state.products.isEmpty) {
                return Center(
                  child: Text(
                    state.productsFailure!.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                );
              }
              if (state.products.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Text(
                      'No products available in this category yet.',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => context.read<CategoriesCubit>().selectCategory(
                  widget.category.id,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: AppSpacing.sm,
                              mainAxisSpacing: AppSpacing.sm,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= state.products.length) {
                              if (state.isLoadingMore) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Center(
                                child: Text(
                                  state.loadMoreFailure!.message,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                ),
                              );
                            }
                            final product = state.products[index];
                            final isWishlisted = wishlistedIds.contains(
                              product.id,
                            );
                            return ProductCard(
                              product: product,
                              isWishlisted: isWishlisted,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRouter.productDetails,
                                arguments: product.id,
                              ),
                              onWishlistTap: () => context
                                  .read<WishlistCubit>()
                                  .toggle(product.id),
                            );
                          },
                          childCount:
                              state.products.length +
                              (state.isLoadingMore ? 1 : 0) +
                              (state.loadMoreFailure != null ? 1 : 0),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
