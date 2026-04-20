import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/controllers/theme_controller.dart';
import 'widgets/verification_bottom_sheet.dart';
import 'widgets/otp_verification_sheet.dart';
import '../auth/widgets/auth_popup.dart';

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
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.1),
                    child: Icon(Icons.person, size: 40, color: AppColors.accent),
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
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
