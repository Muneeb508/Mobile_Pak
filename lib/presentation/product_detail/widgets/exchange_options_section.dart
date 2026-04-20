import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';
import '../../shared/exchange_tier_chip.dart';

class ExchangeOptionsSection extends StatelessWidget {
  final Product product;

  const ExchangeOptionsSection({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.acceptedExchangeTiers.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.swap_horiz, color: AppColors.accent, size: 20),
            SizedBox(width: AppDimensions.gapMedium),
            Text(
              'Exchange Options',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: AppDimensions.gapMedium),
        Wrap(
          spacing: AppDimensions.gapMedium,
          children: product.acceptedExchangeTiers
              .map((tier) => ExchangeTierChip(
                tier: tier,
                isActive: true,
                onTap: () {},
              ))
              .toList(),
        ),
        if (product.exchangeDescription != null &&
            product.exchangeDescription!.isNotEmpty) ...[
          SizedBox(height: AppDimensions.gapMedium),
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Looking for: ${product.exchangeDescription}',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
        SizedBox(height: AppDimensions.gapMedium),
        Container(
          padding: EdgeInsets.all(AppDimensions.paddingSmall),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info, color: AppColors.accent, size: 18),
              SizedBox(width: AppDimensions.gapMedium),
              Expanded(
                child: Text(
                  'You can offer any device matching these price ranges',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
