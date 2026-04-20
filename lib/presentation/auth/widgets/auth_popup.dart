import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/auth_controller.dart';
import '../signup_screen.dart';
import '../login_screen.dart';

class AuthPopup extends StatelessWidget {
  const AuthPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.padding),
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: 0.8),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.shield_outlined,
              size: 64,
              color: AppColors.accent,
            ),
            SizedBox(height: AppDimensions.gapMedium),
            Text(
              "Welcome to Mobile Pak!",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.gapSmall),
            Text(
              "Log in to see our verified sellers and get the best deals!",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.padding),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  gradient: LinearGradient(
                    colors: [AppColors.accent, AppColors.accent.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => const SignupScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                  Get.to(() => const LoginScreen());
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.accent),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            TextButton(
              onPressed: () {
                Get.back(); // Dismiss without logging in
              },
              child: Text(
                'Maybe Later',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
   ),
  );
  }
}

void showAuthPopup() {
  final authController = Get.find<AuthController>();
  if (!authController.isLoggedIn) {
    Get.dialog(const AuthPopup(), barrierDismissible: false);
  }
}
