import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_dimensions.dart';
import 'browse/browse_screen.dart';
import 'sell/sell_screen.dart';
import 'exchange/exchange_screen.dart';
import 'chat/chat_list_screen.dart';
import 'profile/profile_screen.dart';
import '../core/controllers/auth_controller.dart';
import '../core/controllers/wishlist_controller.dart';
import '../core/controllers/browse_controller.dart';
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
      Get.to(() => const SellScreen());
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
    final controller = Get.put(MainScreenController());

    final screens = [
      const BrowseScreen(),
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
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.currentIndex.value == 2 ? 0 : controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz),
                activeIcon: Icon(Icons.swap_horiz),
                label: 'Exchange',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(AppDimensions.paddingSmall),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                label: 'Sell',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_outlined),
                activeIcon: Icon(Icons.chat),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          )),
    );
  }
}
