import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/device_specs.dart';

class DetectedDeviceCard extends StatelessWidget {
  final DeviceSpecs specs;

  const DetectedDeviceCard({
    Key? key,
    required this.specs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final confidencePercent = (specs.confidence * 100).toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.08),
        border: Border.all(color: AppColors.success),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 20,
                  ),
                  SizedBox(width: AppDimensions.gapSmall),
                  Text(
                    'Device Detected',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              Text(
                '$confidencePercent%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapMedium),
          Text(
            '${specs.brand} ${specs.model}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppDimensions.gapSmall),
          Wrap(
            spacing: AppDimensions.gapSmall,
            children: [
              _SpecChip('${specs.storage}'),
              _SpecChip('${specs.ram} RAM'),
              _SpecChip('${specs.batteryHealth} Battery'),
              if (specs.isPtaApproved) _SpecChip('PTA Approved'),
            ],
          ),
          SizedBox(height: AppDimensions.gapMedium),
          Text(
            'Rs ${specs.estimatedPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',')}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
          SizedBox(height: AppDimensions.gapMedium),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: specs.confidence,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;

  const _SpecChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}
