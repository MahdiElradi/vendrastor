import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_category_products_usecase.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({
    required GetCategoriesUseCase getCategoriesUseCase,
    required GetCategoryProductsUseCase getCategoryProductsUseCase,
  })  : _getCategories = getCategoriesUseCase,
        _getCategoryProducts = getCategoryProductsUseCase,
        super(const CategoriesState());

  final GetCategoriesUseCase _getCategories;
  final GetCategoryProductsUseCase _getCategoryProducts;

  Future<void> loadCategories() async {
    emit(state.copyWith(
      isLoadingCategories: true,
      categoriesFailure: null,
    ));
    try {
      final list = await _getCategories();
      emit(state.copyWith(
        categories: list,
        isLoadingCategories: false,
        categoriesFailure: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingCategories: false,
        categoriesFailure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }

  Future<void> selectCategory(String? categoryId) async {
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      products: const [],
      currentPage: 1,
      hasMore: true,
    ));
    if (categoryId == null || categoryId.isEmpty) return;
    await loadProductsPage(categoryId, 1);
  }

  Future<void> loadProductsPage(String categoryId, int page) async {
    if (page == 1) {
      emit(state.copyWith(
        isLoadingProducts: true,
        productsFailure: null,
        loadMoreFailure: null,
      ));
    } else {
      emit(state.copyWith(
        isLoadingMore: true,
        loadMoreFailure: null,
      ));
    }
    try {
      final result = await _getCategoryProducts(categoryId, page: page, pageSize: 20);
      emit(state.copyWith(
        products: page == 1
            ? result.items
            : [...state.products, ...result.items],
        currentPage: result.currentPage,
        hasMore: result.hasMore,
        isLoadingProducts: false,
        isLoadingMore: false,
        productsFailure: null,
        loadMoreFailure: null,
      ));
    } catch (e) {
      final failure = e is Failure ? e : ErrorMapper.fromException(e);
      if (page == 1) {
        emit(state.copyWith(
          isLoadingProducts: false,
          productsFailure: failure,
        ));
      } else {
        emit(state.copyWith(
          isLoadingMore: false,
          loadMoreFailure: failure,
        ));
      }
    }
  }

  Future<void> loadMore() async {
    final id = state.selectedCategoryId;
    if (id == null || state.isLoadingMore || !state.hasMore) return;
    await loadProductsPage(id, state.currentPage + 1);
  }
}
