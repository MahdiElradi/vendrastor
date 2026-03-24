import 'dart:async';

import 'package:flutter/material.dart';

import '../config/theme/app_theme.dart';
import 'asset_or_network_image.dart';
import '../../features/home/domain/entities/banner_entity.dart';
import 'shimmer_loading.dart';

/// Horizontal carousel of banners with auto-scroll and dot indicators.
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
    this.onBannerTap,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  final List<BannerEntity> banners;
  final void Function(BannerEntity)? onBannerTap;
  final bool autoPlay;
  final Duration autoPlayInterval;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.autoPlay && widget.banners.length > 1) {
      _timer = Timer.periodic(widget.autoPlayInterval, (_) {
        if (!_pageController.hasClients) return;
        final nextPage = (_currentPage + 1) % widget.banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    } else {
      _timer = Timer(const Duration(days: 1), () {});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 170,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => widget.onBannerTap?.call(banner),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: banner.imageUrl.isNotEmpty
                          ? AssetOrNetworkImage(
                              imageUrl: banner.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const SkeletonBox();
                            },
                            errorBuilder: (_, __, ___) => _placeholder(context),
                          )
                        : _placeholder(context),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: AppSpacing.sm,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(widget.banners.length, (index) {
                final isActive = index == _currentPage;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 8,
                  height: isActive ? 12 : 8,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(child: Icon(Icons.image_outlined, size: 48)),
    );
  }
}
