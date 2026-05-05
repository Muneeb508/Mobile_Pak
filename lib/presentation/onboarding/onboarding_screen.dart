import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../main_screen.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final RxInt _currentPage = 0.obs;

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      icon: 'search',
      title: 'Find Great Deals',
      subtitle:
          'Browse thousands of verified phones from trusted sellers across Pakistan. Filter by brand, price, and location.',
      color: AppColors.accent,
    ),
    OnboardingPageData(
      icon: 'sell',
      title: 'Sell in Minutes',
      subtitle:
          'Snap a photo, scan your phone, and list it instantly. Get the best price with our smart pricing suggestions.',
      color: Color(0xFFFF6B35),
    ),
    OnboardingPageData(
      icon: 'security',
      title: 'Safe & Secure',
      subtitle:
          'Verified sellers, secure chat, and trusted transactions. Your safety is our top priority.',
      color: AppColors.success,
    ),
    OnboardingPageData(
      icon: 'trending',
      title: 'Smart Insights',
      subtitle:
          'Get price drop alerts, market trends, and smart recommendations. Never miss a great deal.',
      color: Color(0xFF6366F1),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDone() {
    final storage = GetStorage();
    storage.write('seen_onboarding', true);
    Get.off(() => const MainScreen(), transition: Transition.fade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => _currentPage.value < _pages.length - 1
                        ? TextButton(
                            onPressed: _onDone,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 15,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => Text(
                      '${_currentPage.value + 1}/${_pages.length}',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => _currentPage.value = index,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double value = 1.0;
                      if (_pageController.position.haveDimensions) {
                        value = _pageController.page! - index;
                        value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                      }
                      return Transform.scale(
                        scale: value,
                        child: OnboardingPage(
                          data: _pages[index],
                          isActive: _currentPage.value == index,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.padding * 2),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.accent,
                      dotColor: AppColors.border,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  SizedBox(height: AppDimensions.padding * 2),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () {
                          if (_currentPage.value == _pages.length - 1) {
                            _onDone();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          _currentPage.value == _pages.length - 1
                              ? 'Get Started'
                              : 'Next',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
