import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection_container.dart';
import '../../features/auth/presentation/cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';
import '../../features/checkout/presentation/cubit/checkout_cubit.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/product_details/presentation/cubit/product_details_cubit.dart';
import '../../features/product_details/presentation/pages/product_details_page.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/address/presentation/cubit/address_cubit.dart';
import '../../features/address/presentation/pages/addresses_page.dart';
import '../../features/recently_viewed/presentation/cubit/recently_viewed_cubit.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';

/// Central route generator for the app.
/// Named routes for splash, onboarding, auth, home, categories, product, cart,
/// checkout, orders, wishlist, profile, settings.
class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String productDetails = '/product';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String addresses = '/addresses';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final name = routeSettings.name ?? splash;
    if (name == splash) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<SplashCubit>(),
          child: const SplashPage(),
        ),
      );
    }
    if (name == onboarding) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => const OnboardingPage(),
      );
    }
    if (name == login) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<LoginCubit>(),
          child: const LoginPage(),
        ),
      );
    }
    if (name == register) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<RegisterCubit>(),
          child: const RegisterPage(),
        ),
      );
    }
    if (name == forgotPassword) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<ForgotPasswordCubit>(),
          child: const ForgotPasswordPage(),
        ),
      );
    }
    if (name == home) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
            BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider.value(value: sl<WishlistCubit>()),
            BlocProvider<RecentlyViewedCubit>(
              create: (_) => sl<RecentlyViewedCubit>(),
            ),
            BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
          ],
          child: const MainPage(),
        ),
      );
    }
    if (name == categories) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
            BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider.value(value: sl<WishlistCubit>()),
            BlocProvider<RecentlyViewedCubit>(
              create: (_) => sl<RecentlyViewedCubit>(),
            ),
            BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
          ],
          child: const MainPage(initialIndex: 1),
        ),
      );
    }
    if (name == productDetails) {
      final productId = routeSettings.arguments as String?;
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<ProductDetailsCubit>(
              create: (_) => sl<ProductDetailsCubit>(),
            ),
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider.value(value: sl<WishlistCubit>()),
            BlocProvider<RecentlyViewedCubit>(
              create: (_) => sl<RecentlyViewedCubit>(),
            ),
          ],
          child: ProductDetailsPage(productId: productId),
        ),
      );
    }
    if (name == cart) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
            BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider.value(value: sl<WishlistCubit>()),
            BlocProvider<RecentlyViewedCubit>(
              create: (_) => sl<RecentlyViewedCubit>(),
            ),
            BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
          ],
          child: const MainPage(initialIndex: 2),
        ),
      );
    }
    if (name == checkout) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<CheckoutCubit>(),
          child: const CheckoutPage(),
        ),
      );
    }
    if (name == orders) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<OrdersCubit>(),
          child: const OrdersPage(),
        ),
      );
    }
    if (name == wishlist) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
            BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider.value(value: sl<WishlistCubit>()),
            BlocProvider<RecentlyViewedCubit>(
              create: (_) => sl<RecentlyViewedCubit>(),
            ),
            BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()),
          ],
          child: const MainPage(initialIndex: 3),
        ),
      );
    }
    if (name == profile) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()),
            BlocProvider<CategoriesCubit>(create: (_) => sl<CategoriesCubit>()),
            BlocProvider.value(value: sl<CartCubit>()),
            BlocProvider.value(value: sl<WishlistCubit>()),
            BlocProvider<RecentlyViewedCubit>(
              create: (_) => sl<RecentlyViewedCubit>(),
            ),
            BlocProvider<ProfileCubit>(create: (_) => sl<ProfileCubit>()..loadProfile()),
          ],
          child: const MainPage(initialIndex: 4),
        ),
      );
    }
    if (name == addresses) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => BlocProvider(
          create: (_) => sl<AddressCubit>(),
          child: const AddressesPage(),
        ),
      );
    }
    if (name == settings) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: (_) => const SettingsPage(),
      );
    }
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (_) => const SplashPage(),
    );
  }
}
