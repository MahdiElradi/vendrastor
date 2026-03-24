import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/storage/hive_manager.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_state.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
import '../../../wishlist/presentation/pages/wishlist_page.dart';

/// Root scaffold with bottom navigation bar for core app sections.
///
/// The bottom navigation is used instead of a drawer for quick access.
class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const _lastSelectedTabKey = 'last_selected_tab';

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;

    try {
      final storedIndex = HiveManager.settingsBox().get(_lastSelectedTabKey);
      if (storedIndex is int) {
        _selectedIndex = storedIndex;
      }
    } catch (_) {
      // best-effort persistence
    }
  }

  void _saveSelectedIndex(int index) {
    _selectedIndex = index;
    setState(() {});
    try {
      HiveManager.settingsBox().put(_lastSelectedTabKey, index);
    } catch (_) {
      // best-effort persistence
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    _saveSelectedIndex(index);
  }

  void _handleBackPressed() async {
    if (_selectedIndex != 0) {
      _saveSelectedIndex(0);
      return;
    }

    final l10n = context.l10n;
    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.home),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldClose ?? false) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final actions = <Widget>[];
    if (_selectedIndex == 4) {
      actions.add(
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.pushNamed(context, AppRouter.settings),
          tooltip: l10n.settings,
        ),
      );
    }

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _handleBackPressed();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.appTitle), actions: actions),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            HomeTab(),
            CategoriesPage(useScaffold: false),
            CartPage(useScaffold: false),
            WishlistPage(useScaffold: false),
            ProfilePage(useScaffold: false),
          ],
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            return BlocBuilder<WishlistCubit, WishlistState>(
              builder: (context, wishlistState) {
                return BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Theme.of(context).colorScheme.primary,
                  unselectedItemColor: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home_outlined),
                      activeIcon: const Icon(Icons.home),
                      label: l10n.home,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.category_outlined),
                      activeIcon: const Icon(Icons.category),
                      label: l10n.categories,
                    ),
                    BottomNavigationBarItem(
                      icon: _buildBadgeIcon(
                        const Icon(Icons.shopping_cart_outlined),
                        cartState.cart.items.length,
                      ),
                      activeIcon: _buildBadgeIcon(
                        const Icon(Icons.shopping_cart),
                        cartState.cart.items.length,
                      ),
                      label: l10n.cart,
                    ),
                    BottomNavigationBarItem(
                      icon: _buildBadgeIcon(
                        const Icon(Icons.favorite_border),
                        wishlistState.items.length,
                      ),
                      activeIcon: _buildBadgeIcon(
                        const Icon(Icons.favorite),
                        wishlistState.items.length,
                      ),
                      label: l10n.wishlist,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.person_outline),
                      activeIcon: const Icon(Icons.person),
                      label: l10n.profile,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(Widget icon, int count) {
    if (count <= 0) return icon;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
