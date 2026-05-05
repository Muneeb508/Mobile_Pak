import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/recently_viewed_item.dart';

class RecentlyViewedCard extends StatelessWidget {
  final RecentlyViewedItem item;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const RecentlyViewedCard({
    Key? key,
    required this.item,
    required this.onTap,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          child: Stack(
            children: [
              // Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.background,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.background,
                        child: Icon(
                          Icons.image_not_supported,
                          color: AppColors.secondary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  // Details
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title
                          Flexible(
                            child: Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          // Price and Location
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PKR ${item.price}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accent,
                                ),
                              ),
                              SizedBox(height: AppDimensions.gapSmall),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 10,
                                    color: AppColors.secondary,
                                  ),
                                  SizedBox(width: 2),
                                  Flexible(
                                    child: Text(
                                      item.location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Remove button
              if (onRemove != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
