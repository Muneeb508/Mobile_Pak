import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class OnboardingPageData {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;

  const OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;
  final bool isActive;

  const OnboardingPage({
    Key? key,
    required this.data,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding * 2,
        vertical: AppDimensions.padding,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: isSmallScreen ? 20 : 40),
            Container(
              width: isSmallScreen ? 80 : 120,
              height: isSmallScreen ? 80 : 120,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconData(data.icon),
                size: isSmallScreen ? 36 : 56,
                color: data.color,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    fontSize: isSmallScreen ? 20 : null,
                  ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 15,
                color: AppColors.secondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 40),
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'search':
        return Icons.search;
      case 'sell':
        return Icons.sell;
      case 'security':
        return Icons.security;
      case 'trending':
        return Icons.trending_up;
      default:
        return Icons.phone_android;
    }
  }
}
