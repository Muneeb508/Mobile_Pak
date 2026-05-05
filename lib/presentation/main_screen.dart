import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import 'home/home_screen.dart';
import 'sell/scan_screen.dart';
import 'exchange/exchange_screen.dart';
import 'chat/chat_list_screen.dart';
import 'profile/profile_screen.dart';
import '../core/controllers/auth_controller.dart';
import '../core/controllers/wishlist_controller.dart';
import '../core/controllers/browse_controller.dart';
import '../core/controllers/price_alert_controller.dart';
import '../core/controllers/recently_viewed_controller.dart';
import '../core/controllers/smart_tag_controller.dart';
import '../core/controllers/map_controller.dart';
import '../core/controllers/scan_controller.dart';
import '../core/controllers/chat_controller.dart';
import 'auth/widgets/auth_popup.dart';

class MainScreenController extends GetxController {
  final RxInt currentIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(const Duration(milliseconds: 500), () {
      showAuthPopup();
    });
  }

  void changeTab(int index) {
    if (index == 2) {
      Get.to(() => const ScanScreen());
    } else {
      currentIndex.value = index;
    }
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    Get.put(WishlistController());
    Get.put(BrowseController());
    Get.put(PriceAlertController());
    Get.put(RecentlyViewedController());
    Get.put(SmartTagController());
    Get.put(AppMapController());
    Get.put(ScanController());
    Get.put(ChatController());
    final controller = Get.put(MainScreenController());

    final screens = [
      const HomeScreen(),
      const ExchangeScreen(),
      const SizedBox(),
      const ChatListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                      index: 0,
                      controller: controller,
                    ),
                    _buildNavItem(
                      icon: Icons.swap_horiz_outlined,
                      activeIcon: Icons.swap_horiz,
                      label: 'Exchange Phone',
                      index: 1,
                      controller: controller,
                    ),
                    // Center oversized + button
                    GestureDetector(
                      onTap: () => controller.changeTab(2),
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 30),
                      ),
                    ),
                    _buildNavItem(
                      icon: Icons.chat_bubble_outline,
                      activeIcon: Icons.chat_bubble,
                      label: 'Chat',
                      index: 3,
                      controller: controller,
                    ),
                    _buildNavItem(
                      icon: Icons.person_outline,
                      activeIcon: Icons.person,
                      label: 'Profile',
                      index: 4,
                      controller: controller,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required MainScreenController controller,
  }) {
    final isSelected = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 75,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.accent : AppColors.secondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.accent : AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
