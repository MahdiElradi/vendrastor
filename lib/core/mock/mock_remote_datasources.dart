import 'dart:async';
import 'dart:math';

import '../../core/domain/paginated_result.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/models/auth_token_model.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/models/cart_item_model.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/models/category_model.dart';
import '../../features/checkout/data/datasources/checkout_remote_datasource.dart';
import '../../features/home/data/datasources/product_remote_datasource.dart';
import '../../features/home/data/models/banner_model.dart';
import '../../features/home/data/models/product_model.dart';
import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/models/order_model.dart';
import '../../features/wishlist/data/datasources/wishlist_remote_datasource.dart';

/// In-memory mock data store used by mock remote data sources.
///
/// This is intentionally simple and not thread-safe; it is intended for demo /
/// sample apps and development builds.
class MockData {
  MockData._();

  static const _defaultEmail = 'demo@vendrastor.com';

  static final UserModel defaultUser = UserModel(
    id: 'user_1',
    email: _defaultEmail,
    name: 'Jane Doe',
  );

  static String _activeToken = 'token_1';
  static UserModel _activeUser = defaultUser;

  static final List<ProductModel> products = [
    ProductModel(
      id: 'p1',
      title: 'Wireless Headphones',
      price: 79.99,
      imageUrl: 'assets/images/products/pexels-laarkstudio-8281580.jpg',
      description:
          'Enjoy crisp sound and long battery life with these lightweight headphones.',
      rating: 4.5,
      discountPercent: 15,
      categoryId: 'c1',
    ),
    ProductModel(
      id: 'p2',
      title: 'Smartwatch Pro',
      price: 199.99,
      imageUrl: 'assets/images/products/pexels-japy-34624326.jpg',
      description:
          'Track your fitness, monitor your heart rate, and stay connected.',
      rating: 4.2,
      discountPercent: 10,
      categoryId: 'c2',
    ),
    ProductModel(
      id: 'p3',
      title: 'Classic Leather Bag',
      price: 129.99,
      imageUrl:
          'assets/images/products/pexels-micky-jone-299518835-13325931.jpg',
      description: 'A timeless bag perfect for daily use and travel.',
      rating: 4.7,
      discountPercent: 20,
      categoryId: 'c3',
    ),
    ProductModel(
      id: 'p4',
      title: 'Comfort Sneakers',
      price: 89.99,
      imageUrl: 'assets/images/products/pexels-brijeshritz-36267875.jpg',
      description: 'Lightweight sneakers made for all-day comfort.',
      rating: 4.4,
      discountPercent: 0,
      categoryId: 'c3',
    ),
    ProductModel(
      id: 'p5',
      title: 'Fitness Tracker Band',
      price: 49.99,
      imageUrl: 'assets/images/products/pexels-didsss-1190830.jpg',
      description: 'Stay motivated with daily activity tracking and alerts.',
      rating: 4.1,
      discountPercent: 5,
      categoryId: 'c2',
    ),
  ];

  static final List<BannerModel> banners = [
    const BannerModel(
      id: 'b1',
      imageUrl: 'assets/images/banners/pexels-mlkbnl-12194242.jpg',
      title: 'Summer Sale',
      linkUrl: '',
    ),
    const BannerModel(
      id: 'b2',
      imageUrl:
          'assets/images/banners/mohamad-khosravi-YGJ9vfuwyUg-unsplash.jpg',
      title: 'New Arrivals',
      linkUrl: '',
    ),
    const BannerModel(
      id: 'b3',
      imageUrl: 'assets/images/banners/pexels-jibarofoto-13570143.jpg',
      title: 'Best Sellers',
      linkUrl: '',
    ),
  ];

  static final List<CategoryModel> categories = [
    const CategoryModel(
      id: 'c1',
      name: 'Audio',
      imageUrl: 'assets/images/categories/audio.jpg',
    ),
    const CategoryModel(
      id: 'c2',
      name: 'Wearables',
      imageUrl: 'assets/images/categories/wearables.jpg',
    ),
    const CategoryModel(
      id: 'c3',
      name: 'Fashion',
      imageUrl: 'assets/images/categories/fashion.jpg',
    ),
  ];

  static final List<OrderModel> orders = [
    const OrderModel(
      id: 'o1',
      status: 'Delivered',
      total: 259.98,
      createdAt: null,
    ),
    const OrderModel(
      id: 'o2',
      status: 'Processing',
      total: 79.99,
      createdAt: null,
    ),
  ];

  static final Map<String, CartItemModel> cart = <String, CartItemModel>{};
  static final Set<String> wishlist = <String>{};

  static String get activeToken => _activeToken;
  static UserModel get activeUser => _activeUser;

  static void setActiveUser(UserModel user, String token) {
    _activeUser = user;
    _activeToken = token;
  }
}

/// Simple utility to generate easy random identifiers.
String _randomId([String prefix = 'id']) =>
    '${prefix}_${Random().nextInt(100000)}';

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<(UserModel, AuthTokenModel)> login(
    String email,
    String password,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // Accept any credentials for demo purposes.
    final user = email == MockData.defaultUser.email
        ? MockData.defaultUser
        : UserModel(id: _randomId('user'), email: email, name: null);
    final token = AuthTokenModel(
      accessToken: _randomId('token'),
      refreshToken: null,
    );
    MockData.setActiveUser(user, token.accessToken);
    return (user, token);
  }

  @override
  Future<(UserModel, AuthTokenModel)> register(
    String name,
    String email,
    String password,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final user = UserModel(id: _randomId('user'), email: email, name: name);
    final token = AuthTokenModel(
      accessToken: _randomId('token'),
      refreshToken: null,
    );
    MockData.setActiveUser(user, token.accessToken);
    return (user, token);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    // No-op for mock backend.
  }

  @override
  Future<UserModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return MockData.activeUser;
  }

  @override
  Future<UserModel> updateProfile({String? name}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final updated = UserModel(
      id: MockData.activeUser.id,
      email: MockData.activeUser.email,
      name: name ?? MockData.activeUser.name,
    );
    MockData.setActiveUser(updated, MockData.activeToken);
    return updated;
  }
}

class MockProductRemoteDataSource implements ProductRemoteDataSource {
  @override
  Future<List<BannerModel>> getBanners() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return MockData.banners;
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return MockData.products.take(4).toList();
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return MockData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<PaginatedResult<ProductModel>> getProductsPage({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final filtered = categoryId == null
        ? MockData.products
        : MockData.products.where((p) => p.categoryId == categoryId).toList();

    final total = filtered.length;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final pageItems = (start >= total)
        ? <ProductModel>[]
        : filtered.sublist(start, end > total ? total : end);

    return PaginatedResult<ProductModel>(
      items: pageItems,
      currentPage: page,
      totalPages: (total / pageSize).ceil().clamp(1, 999),
      totalCount: total,
    );
  }
}

class MockCategoryRemoteDataSource implements CategoryRemoteDataSource {
  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return MockData.categories;
  }

  @override
  Future<PaginatedResult<ProductModel>> getCategoryProducts(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    final result = await MockProductRemoteDataSource().getProductsPage(
      page: page,
      pageSize: pageSize,
      categoryId: categoryId,
    );
    return result;
  }
}

class MockCartRemoteDataSource implements CartRemoteDataSource {
  @override
  Future<void> addItem(String productId, int quantity) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final existing = MockData.cart[productId];
    if (existing != null) {
      MockData.cart[productId] = CartItemModel(
        productId: existing.productId,
        title: existing.title,
        price: existing.price,
        quantity: existing.quantity + quantity,
        imageUrl: existing.imageUrl,
      );
      return;
    }

    final product = MockData.products.firstWhere(
      (p) => p.id == productId,
      orElse: () =>
          ProductModel(id: productId, title: 'Product $productId', price: 0),
    );

    MockData.cart[productId] = CartItemModel(
      productId: product.id,
      title: product.title,
      price: product.price,
      imageUrl: product.imageUrl,
      quantity: quantity,
    );
  }

  @override
  Future<void> clear() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    MockData.cart.clear();
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return MockData.cart.values.toList();
  }

  @override
  Future<void> removeItem(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    MockData.cart.remove(productId);
  }

  @override
  Future<void> updateItemQuantity(String productId, int quantity) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final existing = MockData.cart[productId];
    if (existing != null) {
      if (quantity <= 0) {
        MockData.cart.remove(productId);
      } else {
        MockData.cart[productId] = CartItemModel(
          productId: existing.productId,
          title: existing.title,
          price: existing.price,
          quantity: quantity,
          imageUrl: existing.imageUrl,
        );
      }
    }
  }
}

class MockWishlistRemoteDataSource implements WishlistRemoteDataSource {
  @override
  Future<void> add(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    MockData.wishlist.add(productId);
  }

  @override
  Future<List<ProductModel>> getWishlist() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return MockData.products
        .where((p) => MockData.wishlist.contains(p.id))
        .toList();
  }

  @override
  Future<void> remove(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    MockData.wishlist.remove(productId);
  }
}

class MockOrdersRemoteDataSource implements OrdersRemoteDataSource {
  @override
  Future<OrderModel?> getOrderById(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return MockData.orders.firstWhere((o) => o.id == orderId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<PaginatedResult<OrderModel>> getOrdersPage({
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final total = MockData.orders.length;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;
    final items = (start >= total)
        ? <OrderModel>[]
        : MockData.orders.sublist(start, end > total ? total : end);
    return PaginatedResult<OrderModel>(
      items: items,
      currentPage: page,
      totalPages: (total / pageSize).ceil().clamp(1, 999),
      totalCount: total,
    );
  }
}

class MockCheckoutRemoteDataSource implements CheckoutRemoteDataSource {
  @override
  Future<OrderModel> placeOrder({String? addressId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final total = MockData.cart.values.fold<double>(
      0,
      (prev, item) => prev + (item.price * item.quantity),
    );
    final order = OrderModel(
      id: _randomId('order'),
      status: 'Processing',
      total: total,
      createdAt: DateTime.now(),
    );
    MockData.orders.insert(0, order);
    MockData.cart.clear();
    return order;
  }
}
