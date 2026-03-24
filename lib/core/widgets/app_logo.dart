import 'package:flutter/material.dart';

import '../config/app_constants.dart';

/// A small branded logo widget used across the app.
class VendraStorLogo extends StatelessWidget {
  const VendraStorLogo({super.key, this.size = 56, this.showText = true});

  /// The size of the icon portion (diameter).
  final double size;

  /// Whether to show the text label next to the icon.
  final bool showText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(size * 0.3),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.shopping_bag,
        size: size * 0.6,
        color: theme.colorScheme.onPrimary,
      ),
    );

    if (!showText) return icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
