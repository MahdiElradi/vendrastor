import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../../home/domain/entities/product_entity.dart';

class CategoriesState {
  const CategoriesState({
    this.categories = const [],
    this.selectedCategoryId,
    this.products = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingCategories = false,
    this.isLoadingProducts = false,
    this.isLoadingMore = false,
    this.categoriesFailure,
    this.productsFailure,
    this.loadMoreFailure,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final List<ProductEntity> products;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingCategories;
  final bool isLoadingProducts;
  final bool isLoadingMore;
  final Failure? categoriesFailure;
  final Failure? productsFailure;
  final Failure? loadMoreFailure;

  CategoriesState copyWith({
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
    List<ProductEntity>? products,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingCategories,
    bool? isLoadingProducts,
    bool? isLoadingMore,
    Failure? categoriesFailure,
    Failure? productsFailure,
    Failure? loadMoreFailure,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      products: products ?? this.products,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingCategories:
          isLoadingCategories ?? this.isLoadingCategories,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      categoriesFailure: categoriesFailure ?? this.categoriesFailure,
      productsFailure: productsFailure ?? this.productsFailure,
      loadMoreFailure: loadMoreFailure ?? this.loadMoreFailure,
    );
  }
}
