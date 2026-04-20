import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/exchange_tier.dart';

class ExchangeTierChip extends StatelessWidget {
  final ExchangeTier tier;
  final bool isActive;
  final VoidCallback onTap;

  const ExchangeTierChip({
    Key? key,
    required this.tier,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.gapSmall,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent.withOpacity(0.12) : Colors.transparent,
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          tier.label,
          style: TextStyle(
            color: isActive ? AppColors.accent : AppColors.secondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
