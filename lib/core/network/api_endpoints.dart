/// Centralized API endpoint paths for the backend.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profile = '/auth/profile';

  // Products
  static const String products = '/products';
  static const String featured = '/products/featured';
  static const String banners = '/banners';
  static const String categories = '/categories';

  // Cart
  static const String cart = '/cart';

  // Checkout
  static const String checkout = '/checkout';

  // Orders
  static const String orders = '/orders';

  // Wishlist
  static const String wishlist = '/wishlist';
}
