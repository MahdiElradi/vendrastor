import 'package:flutter/material.dart';

/// Renders an asset image when the URI begins with `assets/`, otherwise falls
/// back to loading a network image.
///
/// This is useful in demo apps where the same model field may contain either
/// an asset path or an HTTP URL.
class AssetOrNetworkImage extends StatelessWidget {
  const AssetOrNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final ImageLoadingBuilder? loadingBuilder;
  final ImageErrorWidgetBuilder? errorBuilder;

  bool get _isAsset => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    if (_isAsset) {
      return Image.asset(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: errorBuilder,
      );
    }

    return Image.network(
      imageUrl,
      fit: fit,
      width: width,
      height: height,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
    );
  }
}
