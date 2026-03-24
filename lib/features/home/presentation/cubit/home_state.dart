import '../../../../core/error/failures.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/entities/product_entity.dart';

/// Home screen state: banners, featured, products grid, pagination.
class HomeState {
  const HomeState({
    this.banners = const [],
    this.featuredProducts = const [],
    this.products = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingBanners = false,
    this.isLoadingFeatured = false,
    this.isLoadingProducts = false,
    this.isLoadingMore = false,
    this.bannersFailure,
    this.featuredFailure,
    this.productsFailure,
    this.loadMoreFailure,
  });

  final List<BannerEntity> banners;
  final List<ProductEntity> featuredProducts;
  final List<ProductEntity> products;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingBanners;
  final bool isLoadingFeatured;
  final bool isLoadingProducts;
  final bool isLoadingMore;
  final Failure? bannersFailure;
  final Failure? featuredFailure;
  final Failure? productsFailure;
  final Failure? loadMoreFailure;

  HomeState copyWith({
    List<BannerEntity>? banners,
    List<ProductEntity>? featuredProducts,
    List<ProductEntity>? products,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingBanners,
    bool? isLoadingFeatured,
    bool? isLoadingProducts,
    bool? isLoadingMore,
    Failure? bannersFailure,
    Failure? featuredFailure,
    Failure? productsFailure,
    Failure? loadMoreFailure,
  }) {
    return HomeState(
      banners: banners ?? this.banners,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingBanners: isLoadingBanners ?? this.isLoadingBanners,
      isLoadingFeatured: isLoadingFeatured ?? this.isLoadingFeatured,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      bannersFailure: bannersFailure ?? this.bannersFailure,
      featuredFailure: featuredFailure ?? this.featuredFailure,
      productsFailure: productsFailure ?? this.productsFailure,
      loadMoreFailure: loadMoreFailure ?? this.loadMoreFailure,
    );
  }
}
