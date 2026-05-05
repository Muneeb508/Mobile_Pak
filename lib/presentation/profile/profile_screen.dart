import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/controllers/theme_controller.dart';
import '../../presentation/shared/product_card.dart';
import '../../presentation/product_detail/product_detail_screen.dart';
import '../../presentation/shared/widgets/recently_viewed_section.dart';
import 'widgets/verification_bottom_sheet.dart';
import 'widgets/otp_verification_sheet.dart';
import '../auth/widgets/auth_popup.dart';
import '../../core/controllers/wishlist_controller.dart';
import '../demo/price_insight_demo_screen.dart';
import '../demo/market_range_demo_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: AppColors.background,
        actions: [
          Obx(() {
            final themeController = Get.find<ThemeController>();
            return IconButton(
              icon: Icon(themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => themeController.toggleTheme(),
            );
          }),
          Obx(() {
            if (authController.isLoggedIn) {
              return IconButton(
                icon: Icon(Icons.logout),
                onPressed: () => authController.logout(),
              );
            }
            return SizedBox();
          }),
        ],
      ),
      body: Obx(() {
        if (!authController.isLoggedIn) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 80, color: AppColors.secondary),
                SizedBox(height: AppDimensions.padding),
                Text(
                  'Not Logged In',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: AppDimensions.padding),
                ElevatedButton(
                  onPressed: () => showAuthPopup(),
                  child: Text('Log In / Sign Up'),
                ),
              ],
            ),
          );
        }

        final user = authController.currentUser.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: EdgeInsets.all(AppDimensions.padding),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                          backgroundImage: user.avatar.isNotEmpty
                              ? NetworkImage(user.avatar)
                              : null,
                          child: user.avatar.isEmpty
                              ? Icon(Icons.person, size: 50, color: AppColors.accent)
                              : null,
                        ),
                        SizedBox(width: AppDimensions.padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Member since ${user.memberSince}',
                                style: TextStyle(color: AppColors.secondary, fontSize: 12),
                              ),
                              if (user.isTrustedSeller) ...[
                                SizedBox(height: 6),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified, size: 14, color: AppColors.accent),
                                      SizedBox(width: 4),
                                      Text(
                                        'Trusted Seller',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.padding),
                    Row(
                      children: [
                        _buildStatCard('Listings', user.totalListings.toString()),
                        SizedBox(width: AppDimensions.padding),
                        _buildStatCard('Deals', user.successfulDeals.toString()),
                        SizedBox(width: AppDimensions.padding),
                        _buildStatCard('Rating', '${user.rating}⭐'),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.padding * 2),

              // Smart Price Insight Demo
              Container(
                padding: EdgeInsets.all(AppDimensions.padding),
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trending_down, color: AppColors.accent, size: 24),
                        SizedBox(width: AppDimensions.gapMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Smart Price Insight',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                              ),
                              Text(
                                'Analyze product prices intelligently',
                                style: TextStyle(color: AppColors.secondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.gapMedium),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.dashboard),
                        label: Text('View Demo'),
                        onPressed: () => Get.to(() => const PriceInsightDemoScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.padding),

              // Market Range Demo
              Container(
                padding: EdgeInsets.all(AppDimensions.padding),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bar_chart, color: AppColors.info, size: 24),
                        SizedBox(width: AppDimensions.gapMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Market Price Range',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.info,
                                ),
                              ),
                              Text(
                                'Analyze market price distributions',
                                style: TextStyle(color: AppColors.secondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.gapMedium),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.dashboard),
                        label: Text('View Demo'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.info,
                        ),
                        onPressed: () => Get.to(() => const MarketRangeDemoScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppDimensions.padding * 2),

              // Recently Viewed
              RecentlyViewedSection(
                showClearButton: true,
                title: 'Recently Viewed',
              ),

              SizedBox(height: AppDimensions.padding * 2),

              // Wishlist Section
              Obx(() {
                final wishlistController = Get.find<WishlistController>();
                if (wishlistController.itemCount == 0) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Wishlist (${wishlistController.itemCount})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to wishlist view (could be a dedicated screen)
                          },
                          child: Text('View All'),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.gapMedium),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: wishlistController.itemCount > 5
                            ? 5
                            : wishlistController.itemCount,
                        itemBuilder: (context, index) {
                          final productId = wishlistController.wishlistedIds.elementAt(index);
                          // For now, show a placeholder since we don't store full products in wishlist
                          return Container(
                            width: 140,
                            margin: EdgeInsets.only(
                              right: AppDimensions.gapMedium,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.borderRadius,
                              ),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: AppColors.error,
                                        size: 32,
                                      ),
                                      SizedBox(height: AppDimensions.gapSmall),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppDimensions.gapSmall,
                                        ),
                                        child: Text(
                                          'Product $productId',
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => wishlistController
                                        .toggleWishlist(productId),
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
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),

              SizedBox(height: AppDimensions.padding * 2),

              // My Listings
              Text(
                'My Listings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppDimensions.gapMedium),

              Obx(() {
                if (authController.userProducts.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppDimensions.padding),
                      child: Text(
                        'No listings yet',
                        style: TextStyle(color: AppColors.secondary),
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppDimensions.padding,
                    mainAxisSpacing: AppDimensions.padding,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: authController.userProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: authController.userProducts[index],
                      onTap: () {
                        Get.to(() => ProductDetailScreen(
                          product: authController.userProducts[index],
                        ));
                      },
                    );
                  },
                );
              }),

              SizedBox(height: AppDimensions.padding * 2),
              Text(
                'Trust & Verification',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: AppDimensions.gapMedium),

              // ID Card Verification Option
              _buildVerificationCard(
                context: context,
                title: 'ID Card Verification',
                description: 'Upload your ID card for a Trusted Seller badge',
                icon: Icons.badge_outlined,
                isVerified: authController.isIdVerified.value,
                onTap: () {
                  if (!authController.isIdVerified.value) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.borderRadiusLarge)),
                      ),
                      builder: (context) => const VerificationBottomSheet(),
                    );
                  }
                },
              ),

              SizedBox(height: AppDimensions.gapMedium),

              // OTP Verification Option
              _buildVerificationCard(
                context: context,
                title: 'Phone Verification',
                description: 'Verify phone via OTP if you don\'t have an ID',
                icon: Icons.phone_android,
                isVerified: authController.isPhoneVerified.value,
                onTap: () {
                  if (!authController.isPhoneVerified.value) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimensions.borderRadiusLarge)),
                      ),
                      builder: (context) => const OtpVerificationSheet(),
                    );
                  }
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppDimensions.gapSmall),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required bool isVerified,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.padding),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          border: Border.all(
            color: isVerified ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isVerified ? AppColors.accent.withValues(alpha: 0.1) : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isVerified ? AppColors.accent : AppColors.secondary,
              ),
            ),
            SizedBox(width: AppDimensions.padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isVerified)
              Icon(Icons.check_circle, color: AppColors.accent)
            else
              Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}
