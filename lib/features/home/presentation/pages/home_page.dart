import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_theme.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/banner_carousel.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/recently_viewed_section.dart';
import '../../../recently_viewed/presentation/cubit/recently_viewed_cubit.dart';

/// Home: banners, featured products, product grid with pagination.
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _search = '';
  _HomeFilter _filter = _HomeFilter.all;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadInitial();
    context.read<RecentlyViewedCubit>().load();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<HomeCubit>();
    final state = cubit.state;
    if (!state.hasMore || state.isLoadingMore) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      cubit.loadMore();
    }
  }

  void _scrollToTop() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProductEntity> _applySearchFilter(HomeState state) {
    final query = _search.trim().toLowerCase();
    final base = state.products;
    final filtered = base.where((p) {
      final matchesQuery =
          query.isEmpty ||
          p.title.toLowerCase().contains(query) ||
          (p.description?.toLowerCase().contains(query) ?? false);
      if (!matchesQuery) return false;
      if (_filter == _HomeFilter.deals) {
        return (p.discountPercent ?? 0) > 0;
      }
      if (_filter == _HomeFilter.topRated) {
        return (p.rating ?? 0) >= 4.5;
      }
      return true;
    }).toList();
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isLoading =
            state.isLoadingBanners &&
            state.isLoadingFeatured &&
            state.isLoadingProducts;
        if (isLoading && state.products.isEmpty) {
          return _buildLoadingSkeleton(context);
        }

        final filteredProducts = _applySearchFilter(state);
        final deals = state.featuredProducts
            .where((p) => (p.discountPercent ?? 0) > 0)
            .toList();

        return BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, wishlistState) {
            final wishlistedIds = wishlistState.items
                .map((product) => product.id)
                .toSet();

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().loadInitial(),
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSearchBar(context),
                  if (state.banners.isNotEmpty) _buildBannerSection(state),
                  const SliverToBoxAdapter(child: RecentlyViewedSection()),
                  if (deals.isNotEmpty)
                    _buildDealsSection(context, deals, wishlistedIds),
                  _buildProductsHeader(context),
                  if (state.productsFailure != null)
                    _buildErrorSection(context, state.productsFailure!.message)
                  else if (filteredProducts.isEmpty && !state.isLoadingProducts)
                    const SliverFillRemaining(
                      child: Center(child: Text('No products found')),
                    )
                  else
                    _buildProductsGrid(
                      context,
                      filteredProducts,
                      wishlistedIds,
                    ),
                  if (state.isLoadingMore) _buildLoadingMore(),
                  if (state.loadMoreFailure != null)
                    _buildErrorSection(context, state.loadMoreFailure!.message),
                ],
              ),
            );
          },
        );
      },
    );
  }

  SliverToBoxAdapter _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _search = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: _HomeFilter.values.map((filter) {
                final selected = _filter == filter;
                return ChoiceChip(
                  label: Text(filter.label),
                  selected: selected,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  onSelected: (_) => setState(() => _filter = filter),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildBannerSection(HomeState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.md,
        ),
        child: BannerCarousel(banners: state.banners),
      ),
    );
  }

  SliverToBoxAdapter _buildDealsSection(
    BuildContext context,
    List<ProductEntity> deals,
    Set<String> wishlistedIds,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hot deals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    setState(() => _filter = _HomeFilter.deals);
                    _scrollToTop();
                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                itemCount: deals.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final product = deals[index];
                  final isWishlisted = wishlistedIds.contains(product.id);
                  return SizedBox(
                    width: 170,
                    child: ProductCard(
                      product: product,
                      isWishlisted: isWishlisted,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.productDetails,
                        arguments: product.id,
                      ),
                      onWishlistTap: () =>
                          context.read<WishlistCubit>().toggle(product.id),
                      onAddToCart: () =>
                          context.read<CartCubit>().addToCart(product.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildProductsHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Products', style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: () {
                setState(() => _filter = _HomeFilter.all);
                _scrollToTop();
              },
              child: Text(
                'View all',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildErrorSection(BuildContext context, String message) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildProductsGrid(
    BuildContext context,
    List<ProductEntity> products,
    Set<String> wishlistedIds,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.72,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = products[index];
          final isWishlisted = wishlistedIds.contains(product.id);
          return ProductCard(
            product: product,
            isWishlisted: isWishlisted,
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.productDetails,
              arguments: product.id,
            ),
            onWishlistTap: () =>
                context.read<WishlistCubit>().toggle(product.id),
          );
        }, childCount: products.length),
      ),
    );
  }

  SliverToBoxAdapter _buildLoadingMore() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SkeletonBox(height: 22, width: 140),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 48),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  const SizedBox(width: 260, child: SkeletonBox(height: 180)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: const SkeletonBox(height: 180),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _HomeFilter { all, deals, topRated }

extension on _HomeFilter {
  String get label {
    switch (this) {
      case _HomeFilter.all:
        return 'All';
      case _HomeFilter.deals:
        return 'Deals';
      case _HomeFilter.topRated:
        return 'Top rated';
    }
  }
}

/// Legacy route widget (used by routing).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomeTab());
  }
}
