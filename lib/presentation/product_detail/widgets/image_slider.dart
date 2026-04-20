import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ImageSlider extends StatelessWidget {
  final List<String> images;
  final PageController pageController;
  final Function(int) onPageChanged;
  final int currentIndex;

  const ImageSlider({
    Key? key,
    required this.images,
    required this.pageController,
    required this.onPageChanged,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      color: AppColors.card,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: images.isEmpty ? 1 : images.length,
            itemBuilder: (context, index) {
              if (images.isEmpty) {
                return Container(
                  color: AppColors.background,
                  child: Icon(Icons.image_not_supported, color: AppColors.secondary),
                );
              }
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.background,
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.background,
                  child: Icon(Icons.image_not_supported, color: AppColors.secondary),
                ),
              );
            },
          ),
          Positioned(
            bottom: AppDimensions.padding,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: pageController,
                count: images.isEmpty ? 1 : images.length,
                effect: ExpandingDotsEffect(
                  dotColor: AppColors.secondary.withValues(alpha: 0.3),
                  activeDotColor: AppColors.accent,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
