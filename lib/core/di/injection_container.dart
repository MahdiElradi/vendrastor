import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../mock/mock_remote_datasources.dart';
import '../network/dio_client.dart';
import '../storage/auth_token_storage.dart';
import '../storage/auth_token_storage_impl.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories_impl/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/cart/data/datasources/cart_local_datasource_impl.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/repositories_impl/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_item_quantity_usecase.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/repositories_impl/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/categories/domain/usecases/get_category_products_usecase.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/checkout/data/datasources/checkout_remote_datasource.dart';
import '../../features/checkout/data/repositories_impl/checkout_repository_impl.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/checkout/domain/usecases/place_order_usecase.dart';
import '../../features/checkout/presentation/cubit/checkout_cubit.dart';
import '../../features/home/data/datasources/product_local_datasource.dart';
import '../../features/home/data/datasources/product_local_datasource_impl.dart';
import '../../features/home/data/datasources/product_remote_datasource.dart';
import '../../features/home/data/repositories_impl/product_repository_impl.dart';
import '../../features/home/domain/repositories/product_repository.dart';
import '../../features/home/domain/usecases/get_featured_products_usecase.dart';
import '../../features/home/domain/usecases/get_home_banners_usecase.dart';
import '../../features/home/domain/usecases/get_products_page_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import '../../features/onboarding/domain/usecases/is_onboarding_complete_usecase.dart';
import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/repositories_impl/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_orders_page_usecase.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/product_details/domain/usecases/get_product_details_usecase.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../features/splash/domain/usecases/check_auth_status_usecase.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/wishlist/data/datasources/wishlist_local_datasource.dart';
import '../../features/wishlist/data/datasources/wishlist_local_datasource_impl.dart';
import '../../features/wishlist/data/datasources/wishlist_remote_datasource.dart';
import '../../features/wishlist/data/repositories_impl/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import '../../features/wishlist/domain/usecases/toggle_wishlist_item_usecase.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/settings/data/datasources/settings_local_datasource.dart';
import '../../features/settings/data/datasources/settings_local_datasource_impl.dart';
import '../../features/settings/data/repositories_impl/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/change_language_usecase.dart';
import '../../features/settings/domain/usecases/change_theme_mode_usecase.dart';
import '../../features/settings/domain/usecases/get_saved_settings_usecase.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/address/data/datasources/address_local_datasource.dart';
import '../../features/address/data/repositories_impl/address_repository_impl.dart';
import '../../features/address/domain/repositories/address_repository.dart';
import '../../features/address/domain/usecases/add_address_usecase.dart';
import '../../features/address/domain/usecases/delete_address_usecase.dart';
import '../../features/address/domain/usecases/get_addresses_usecase.dart';
import '../../features/address/domain/usecases/set_default_address_usecase.dart';
import '../../features/address/domain/usecases/update_address_usecase.dart';
import '../../features/address/presentation/cubit/address_cubit.dart';
import '../../features/recently_viewed/data/datasources/recently_viewed_local_datasource.dart';
import '../../features/recently_viewed/data/repositories_impl/recently_viewed_repository_impl.dart';
import '../../features/recently_viewed/domain/repositories/recently_viewed_repository.dart';
import '../../features/recently_viewed/domain/usecases/add_recently_viewed_usecase.dart';
import '../../features/recently_viewed/domain/usecases/get_recently_viewed_usecase.dart';
import '../../features/recently_viewed/presentation/cubit/recently_viewed_cubit.dart';

final GetIt sl = GetIt.instance;

/// Dependency injection setup using get_it.
/// Call from main.dart before runApp after Hive and storage are ready.
Future<void> initGetIt() async {
  // Storage (secure token storage)
  sl.registerLazySingleton<AuthTokenStorage>(AuthTokenStorageImpl.new);

  // Networking
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      authTokenStorage: sl<AuthTokenStorage>(),
      onAuthError: _onAuthError,
    ),
  );
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  // Auth feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => MockAuthRemoteDataSource(),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remote: sl<AuthRemoteDataSource>(),
      tokenStorage: sl<AuthTokenStorage>(),
    ),
  );
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sl<LogoutUseCase>()));
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      loginUseCase: sl<LoginUseCase>(),
      authCubit: sl<AuthCubit>(),
    ),
  );
  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(
      registerUseCase: sl<RegisterUseCase>(),
      authCubit: sl<AuthCubit>(),
    ),
  );
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(sl<ForgotPasswordUseCase>()),
  );

  // Splash
  sl.registerLazySingleton<CheckAuthStatusUseCase>(
    () => CheckAuthStatusUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<IsOnboardingCompleteUseCase>(
    IsOnboardingCompleteUseCase.new,
  );
  sl.registerLazySingleton<CompleteOnboardingUseCase>(
    CompleteOnboardingUseCase.new,
  );
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(
      checkAuthStatusUseCase: sl<CheckAuthStatusUseCase>(),
      authCubit: sl<AuthCubit>(),
      isOnboardingCompleteUseCase: sl<IsOnboardingCompleteUseCase>(),
    ),
  );

  // Home / Products
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => MockProductRemoteDataSource(),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    ProductLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remote: sl<ProductRemoteDataSource>(),
      local: sl<ProductLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetHomeBannersUseCase>(
    () => GetHomeBannersUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetFeaturedProductsUseCase>(
    () => GetFeaturedProductsUseCase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton<GetProductsPageUseCase>(
    () => GetProductsPageUseCase(sl<ProductRepository>()),
  );
  sl.registerFactory<HomeCubit>(
    () => HomeCubit(
      getHomeBannersUseCase: sl<GetHomeBannersUseCase>(),
      getFeaturedProductsUseCase: sl<GetFeaturedProductsUseCase>(),
      getProductsPageUseCase: sl<GetProductsPageUseCase>(),
    ),
  );

  // Categories
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => MockCategoryRemoteDataSource(),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(sl<CategoryRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl<CategoryRepository>()),
  );
  sl.registerLazySingleton<GetCategoryProductsUseCase>(
    () => GetCategoryProductsUseCase(sl<CategoryRepository>()),
  );
  sl.registerFactory<CategoriesCubit>(
    () => CategoriesCubit(
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
      getCategoryProductsUseCase: sl<GetCategoryProductsUseCase>(),
    ),
  );

  // Product Details
  sl.registerLazySingleton<GetProductDetailsUseCase>(
    () => GetProductDetailsUseCase(sl<ProductRepository>()),
  );
  sl.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(sl<GetProductDetailsUseCase>()),
  );

  // Cart
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => MockCartRemoteDataSource(),
  );
  sl.registerLazySingleton<CartLocalDataSource>(CartLocalDataSourceImpl.new);
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(
      remote: sl<CartRemoteDataSource>(),
      local: sl<CartLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetCartUseCase>(
    () => GetCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<UpdateCartItemQuantityUseCase>(
    () => UpdateCartItemQuantityUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(sl<CartRepository>()),
  );
  sl.registerLazySingleton<CartCubit>(
    () => CartCubit(
      getCartUseCase: sl<GetCartUseCase>(),
      addToCartUseCase: sl<AddToCartUseCase>(),
      removeFromCartUseCase: sl<RemoveFromCartUseCase>(),
      updateQuantityUseCase: sl<UpdateCartItemQuantityUseCase>(),
      clearCartUseCase: sl<ClearCartUseCase>(),
    ),
  );

  // Checkout
  sl.registerLazySingleton<CheckoutRemoteDataSource>(
    () => MockCheckoutRemoteDataSource(),
  );
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(sl<CheckoutRemoteDataSource>()),
  );
  sl.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(sl<CheckoutRepository>()),
  );
  sl.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(sl<PlaceOrderUseCase>()),
  );

  // Orders
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => MockOrdersRemoteDataSource(),
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(sl<OrdersRemoteDataSource>()),
  );
  sl.registerLazySingleton<GetOrdersPageUseCase>(
    () => GetOrdersPageUseCase(sl<OrdersRepository>()),
  );
  sl.registerFactory<OrdersCubit>(
    () => OrdersCubit(sl<GetOrdersPageUseCase>()),
  );

  // Wishlist
  sl.registerLazySingleton<WishlistRemoteDataSource>(
    () => MockWishlistRemoteDataSource(),
  );
  sl.registerLazySingleton<WishlistLocalDataSource>(
    WishlistLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(
      remote: sl<WishlistRemoteDataSource>(),
      local: sl<WishlistLocalDataSource>(),
    ),
  );
  sl.registerLazySingleton<GetWishlistUseCase>(
    () => GetWishlistUseCase(sl<WishlistRepository>()),
  );
  sl.registerLazySingleton<ToggleWishlistItemUseCase>(
    () => ToggleWishlistItemUseCase(sl<WishlistRepository>()),
  );
  sl.registerLazySingleton<WishlistCubit>(
    () => WishlistCubit(
      getWishlistUseCase: sl<GetWishlistUseCase>(),
      toggleWishlistItemUseCase: sl<ToggleWishlistItemUseCase>(),
    ),
  );

  // Settings
  sl.registerLazySingleton<SettingsLocalDataSource>(
    SettingsLocalDataSourceImpl.new,
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
  );
  sl.registerLazySingleton<GetSavedSettingsUseCase>(
    () => GetSavedSettingsUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<ChangeThemeModeUseCase>(
    () => ChangeThemeModeUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<ChangeLanguageUseCase>(
    () => ChangeLanguageUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(
      sl<GetSavedSettingsUseCase>(),
      sl<ChangeThemeModeUseCase>(),
      sl<ChangeLanguageUseCase>(),
    ),
  );

  // Address management
  sl.registerLazySingleton<AddressLocalDataSource>(
    () => AddressLocalDataSource(),
  );
  sl.registerLazySingleton<AddressRepository>(
    () => AddressRepositoryImpl(sl<AddressLocalDataSource>()),
  );
  sl.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<DeleteAddressUseCase>(
    () => DeleteAddressUseCase(sl<AddressRepository>()),
  );
  sl.registerLazySingleton<SetDefaultAddressUseCase>(
    () => SetDefaultAddressUseCase(sl<AddressRepository>()),
  );
  sl.registerFactory<AddressCubit>(
    () => AddressCubit(
      sl<GetAddressesUseCase>(),
      sl<AddAddressUseCase>(),
      sl<UpdateAddressUseCase>(),
      sl<DeleteAddressUseCase>(),
      sl<SetDefaultAddressUseCase>(),
    ),
  );

  // Recently viewed
  sl.registerLazySingleton<RecentlyViewedLocalDataSource>(
    () => RecentlyViewedLocalDataSource(),
  );
  sl.registerLazySingleton<RecentlyViewedRepository>(
    () => RecentlyViewedRepositoryImpl(
      sl<RecentlyViewedLocalDataSource>(),
      sl<ProductRepository>(),
    ),
  );
  sl.registerLazySingleton<GetRecentlyViewedUseCase>(
    () => GetRecentlyViewedUseCase(sl<RecentlyViewedRepository>()),
  );
  sl.registerLazySingleton<AddRecentlyViewedUseCase>(
    () => AddRecentlyViewedUseCase(sl<RecentlyViewedRepository>()),
  );
  sl.registerFactory<RecentlyViewedCubit>(
    () => RecentlyViewedCubit(
      getRecentlyViewedUseCase: sl<GetRecentlyViewedUseCase>(),
      addRecentlyViewedUseCase: sl<AddRecentlyViewedUseCase>(),
      getProductDetailsUseCase: sl<GetProductDetailsUseCase>(),
    ),
  );

  // Profile
  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      sl<GetProfileUseCase>(),
      sl<UpdateProfileUseCase>(),
      sl<LogoutUseCase>(),
      sl<AuthCubit>(),
    ),
  );
}

void _onAuthError(DioException err, ErrorInterceptorHandler handler) {
  // Optional: trigger global logout or token refresh from here.
  // For now, DioClient clears tokens in the interceptor; this callback
  // can be used to navigate to login or refresh token.
  handler.next(err);
}
