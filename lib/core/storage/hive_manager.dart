import 'package:hive_flutter/hive_flutter.dart';

/// Box name constants for Hive.
abstract class HiveBox {
  HiveBox._();

  static const String settings = 'settings';
  static const String userProfile = 'user_profile';
  static const String products = 'products';
  static const String banners = 'banners';
  static const String categories = 'categories';
  static const String cart = 'cart';
  static const String wishlist = 'wishlist';
  static const String orders = 'orders';
  static const String onboarding = 'onboarding';
}

/// Initializes Hive (Flutter) and opens app boxes.
class HiveManager {
  HiveManager._();

  static bool _initialized = false;
  static Future<void>? _initializing;

  static Future<void> init() async {
    if (_initialized) return;
    if (_initializing != null) return _initializing!;

    _initializing = _doInit();
    await _initializing;
  }

  static Future<void> _doInit() async {
    try {
      await Hive.initFlutter();
      await openAppBoxes();
      _initialized = true;
    } catch (e) {
      // Bubble to caller for fatal error handling.
      _initializing = null;
      rethrow;
    }
  }

  static Future<void> openAppBoxes() async {
    await Future.wait(<Future<void>>[
      openBox<dynamic>(HiveBox.settings),
      openBox<dynamic>(HiveBox.userProfile),
      openBox<dynamic>(HiveBox.products),
      openBox<dynamic>(HiveBox.banners),
      openBox<dynamic>(HiveBox.categories),
      openBox<dynamic>(HiveBox.cart),
      openBox<dynamic>(HiveBox.wishlist),
      openBox<dynamic>(HiveBox.orders),
      openBox<dynamic>(HiveBox.onboarding),
    ]);
  }

  static Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }

    try {
      return await Hive.openBox<T>(name);
    } on HiveError catch (_) {
      if (Hive.isBoxOpen(name)) {
        // If concurrent init opened the box just now, return it.
        return Hive.box<T>(name);
      }
      rethrow;
    }
  }

  static Box<T> box<T>(String name) {
    if (!_initialized && !Hive.isBoxOpen(name)) {
      throw StateError(
        'HiveManager has not been initialized. Call HiveManager.init() before using HiveManager.box()',
      );
    }

    if (!Hive.isBoxOpen(name)) {
      throw StateError(
        'Box "$name" is not open. Ensure HiveManager.init() succeeded.',
      );
    }

    return Hive.box<T>(name);
  }

  /// Canonical accessor for the shared settings box.
  ///
  /// Keep this typed as dynamic across the app to avoid runtime type
  /// mismatches when different features read/write heterogeneous values.
  static Box<dynamic> settingsBox() {
    return box<dynamic>(HiveBox.settings);
  }
}
