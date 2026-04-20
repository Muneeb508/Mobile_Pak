import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class SafetyTipsBanner extends StatelessWidget {
  const SafetyTipsBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: AppColors.warning, size: 22),
              SizedBox(width: AppDimensions.gapMedium),
              Text(
                'Safety Tips',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapMedium),
          _SafetyTip(
            icon: Icons.location_on,
            text: 'Meet the seller in person at a safe public location',
          ),
          _SafetyTip(
            icon: Icons.money_off,
            text: 'Never pay in advance or through insecure payment methods',
          ),
          _SafetyTip(
            icon: Icons.phone_android,
            text: 'Verify IMEI and original phone packaging before purchase',
          ),
        ],
      ),
    );
  }
}

class _SafetyTip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SafetyTip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimensions.gapSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.warning, size: 18),
          SizedBox(width: AppDimensions.gapMedium),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
