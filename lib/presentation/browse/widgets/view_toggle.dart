import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class ViewToggle extends StatelessWidget {
  final bool isMapView;
  final VoidCallback onToggle;

  const ViewToggle({
    Key? key,
    required this.isMapView,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: isMapView ? onToggle : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isMapView ? Colors.transparent : AppColors.accent,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Icon(
                  Icons.grid_view,
                  color: isMapView ? AppColors.secondary : Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: isMapView ? null : onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isMapView ? AppColors.accent : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.borderRadius),
                ),
                child: Icon(
                  Icons.map_outlined,
                  color: isMapView ? Colors.white : AppColors.secondary,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
