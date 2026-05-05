import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';
import '../../shared/verified_badge.dart';

class MapProductPreview extends StatelessWidget {
  final Product product;
  final VoidCallback onDismiss;
  final VoidCallback onViewListing;

  const MapProductPreview({
    Key? key,
    required this.product,
    required this.onDismiss,
    required this.onViewListing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: AppDimensions.paddingSmall,
              bottom: AppDimensions.paddingSmall,
            ),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadius),
                      child: CachedNetworkImage(
                        imageUrl: product.images.isNotEmpty
                            ? product.images.first
                            : '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.background,
                          child: const Icon(Icons.image_not_supported),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimensions.padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: AppDimensions.gapSmall),
                          Text(
                            product.formattedPrice,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent,
                            ),
                          ),
                          SizedBox(height: AppDimensions.gapSmall),
                          Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 16,
                                color: AppColors.accent,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${product.seller.rating}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: AppDimensions.gapSmall),
                              if (product.isVerified) VerifiedBadge(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onDismiss,
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.padding),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.location,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            product.distance,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.padding),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onViewListing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusLarge,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: AppDimensions.paddingSmall,
                      ),
                    ),
                    child: const Text(
                      'View Listing',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
