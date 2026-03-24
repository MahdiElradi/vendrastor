import 'package:flutter/material.dart';

/// Reusable loading indicator.
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: size / 8,
          valueColor: color != null ? AlwaysStoppedAnimation(color) : null,
        ),
      ),
    );
  }
}
