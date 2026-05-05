import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/recently_viewed_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../data/models/user_model.dart';
import '../../../presentation/product_detail/product_detail_screen.dart';
import 'recently_viewed_card.dart';

class RecentlyViewedSection extends StatelessWidget {
  final bool showClearButton;
  final String title;

  const RecentlyViewedSection({
    Key? key,
    this.showClearButton = true,
    this.title = 'Recently Viewed',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecentlyViewedController>();

    return Obx(() {
      if (!controller.hasItems) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and clear button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (showClearButton)
                  GestureDetector(
                    onTap: () => _showClearDialog(context, controller),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppDimensions.gapMedium),
            // Horizontal scrollable list
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.recentlyViewedItems.length,
                  (index) {
                    final item = controller.recentlyViewedItems[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: AppDimensions.gapMedium,
                      ),
                      child: RecentlyViewedCard(
                        item: item,
                        onTap: () {
                          // Navigate to product detail
                          Get.to(() => ProductDetailScreen(
                            product: Product(
                              id: item.productId,
                              title: item.title,
                              description: '',
                              priceValue: item.price,
                              images: [item.imageUrl],
                              specs: [],
                              location: item.location,
                              distance: '',
                              seller: UserModel(
                                id: 'seller_unknown',
                                name: 'Seller',
                                avatar: '',
                                joinedAt: DateTime.now(),
                                isPhoneVerified: false,
                                isCnicVerified: false,
                                isTrustedSeller: false,
                                totalListings: 0,
                                successfulDeals: 0,
                                rating: 0,
                              ),
                              postedAt: item.viewedAt,
                              isVerified: false,
                              isPtaApproved: false,
                              isHotDeal: false,
                              isExchangeAvailable: false,
                              condition: '',
                              batteryHealth: '',
                              storage: '',
                              listingType: 'sell',
                              acceptedExchangeTiers: const [],
                            ),
                          ));
                        },
                        onRemove: () => controller.removeItem(item.productId),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showClearDialog(BuildContext context, RecentlyViewedController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear Recently Viewed?'),
        content: const Text(
          'This will remove all items from your recently viewed list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearRecentlyViewed();
              Get.back();
            },
            child: Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
