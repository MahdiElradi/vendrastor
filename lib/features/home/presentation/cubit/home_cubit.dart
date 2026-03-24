import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/error_mapper.dart';
import '../../domain/usecases/get_featured_products_usecase.dart';
import '../../domain/usecases/get_home_banners_usecase.dart';
import '../../domain/usecases/get_products_page_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetHomeBannersUseCase getHomeBannersUseCase,
    required GetFeaturedProductsUseCase getFeaturedProductsUseCase,
    required GetProductsPageUseCase getProductsPageUseCase,
  })  : _getBanners = getHomeBannersUseCase,
        _getFeatured = getFeaturedProductsUseCase,
        _getProductsPage = getProductsPageUseCase,
        super(const HomeState());

  final GetHomeBannersUseCase _getBanners;
  final GetFeaturedProductsUseCase _getFeatured;
  final GetProductsPageUseCase _getProductsPage;

  Future<void> loadInitial() async {
    emit(state.copyWith(
      isLoadingBanners: true,
      isLoadingFeatured: true,
      isLoadingProducts: true,
      bannersFailure: null,
      featuredFailure: null,
      productsFailure: null,
    ));
    await Future.wait(<Future<void>>[
      _loadBanners(),
      _loadFeatured(),
      _loadProductsPage(1),
    ]);
  }

  Future<void> _loadBanners() async {
    try {
      final banners = await _getBanners();
      emit(state.copyWith(
        banners: banners,
        isLoadingBanners: false,
        bannersFailure: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingBanners: false,
        bannersFailure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }

  Future<void> _loadFeatured() async {
    try {
      final list = await _getFeatured();
      emit(state.copyWith(
        featuredProducts: list,
        isLoadingFeatured: false,
        featuredFailure: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingFeatured: false,
        featuredFailure: e is Failure ? e : ErrorMapper.fromException(e),
      ));
    }
  }

  Future<void> _loadProductsPage(int page) async {
    try {
      final result = await _getProductsPage(page: page, pageSize: 20);
      emit(state.copyWith(
        products: page == 1 ? result.items : [...state.products, ...result.items],
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
    if (state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailure: null));
    await _loadProductsPage(state.currentPage + 1);
  }
}
