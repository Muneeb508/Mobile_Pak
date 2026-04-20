import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';

class SpecsSection extends StatelessWidget {
  final Product product;

  const SpecsSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: AppDimensions.gapMedium),
        Wrap(
          spacing: AppDimensions.gapMedium,
          runSpacing: AppDimensions.gapMedium,
          children: [
            _SpecChip(label: 'Storage', value: product.storage),
            _SpecChip(label: 'Condition', value: product.condition),
            _SpecChip(label: 'Battery', value: product.batteryHealth),
            _SpecChip(label: 'PTA', value: product.isPtaApproved ? 'Approved ✔' : 'Not Approved'),
          ],
        ),
        if (product.specs.isNotEmpty) ...[
          SizedBox(height: AppDimensions.gapMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: product.specs
                .map((spec) => Padding(
                  padding: EdgeInsets.symmetric(vertical: AppDimensions.gapSmall),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.accent, size: 18),
                      SizedBox(width: AppDimensions.gapMedium),
                      Text(spec, style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _SpecChip extends StatelessWidget {
  final String label;
  final String value;

  const _SpecChip({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.gapMedium,
        vertical: AppDimensions.gapSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.secondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
