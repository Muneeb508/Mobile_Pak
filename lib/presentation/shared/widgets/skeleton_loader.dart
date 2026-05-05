import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonLoader({
    Key? key,
    this.width,
    this.height,
    this.borderRadius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.card,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        color: AppColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            width: double.infinity,
            height: 140,
            borderRadius: AppDimensions.borderRadiusLarge,
          ),
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 16),
                SizedBox(height: AppDimensions.gapSmall),
                SkeletonLoader(width: 100, height: 12),
                SizedBox(height: AppDimensions.gapSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SkeletonLoader(width: 80, height: 18),
                    SkeletonLoader(width: 50, height: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.gapMedium),
      child: Row(
        children: [
          SkeletonLoader(
            width: 56,
            height: 56,
            borderRadius: 12,
          ),
          SizedBox(width: AppDimensions.gapMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 16),
                SizedBox(height: AppDimensions.gapSmall),
                SkeletonLoader(width: 150, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            width: double.infinity,
            height: 300,
          ),
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 200, height: 24),
                SizedBox(height: AppDimensions.padding),
                SkeletonLoader(width: 120, height: 28),
                SizedBox(height: AppDimensions.padding),
                SkeletonLoader(width: double.infinity, height: 16),
                SizedBox(height: AppDimensions.gapMedium),
                SkeletonLoader(width: double.infinity, height: 16),
                SizedBox(height: AppDimensions.padding),
                SkeletonLoader(width: double.infinity, height: 100),
                SizedBox(height: AppDimensions.padding),
                SkeletonLoader(width: double.infinity, height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: SkeletonLoader(
              width: double.infinity,
              height: 48,
              borderRadius: 12,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => SizedBox(width: AppDimensions.gapMedium),
                itemBuilder: (_, __) => SkeletonLoader(
                  width: 80,
                  height: 32,
                  borderRadius: 16,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.padding),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: AppDimensions.gapMedium,
                mainAxisSpacing: AppDimensions.gapMedium,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => const ProductCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}
