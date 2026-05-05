import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/market_price_range.dart';
import '../../../services/market_price_range_service.dart';

class MarketPriceRangeCard extends StatelessWidget {
  final int listingPrice;
  final MarketPriceRange marketRange;

  const MarketPriceRangeCard({
    Key? key,
    required this.listingPrice,
    required this.marketRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = MarketPriceRangeService.getPriceStatus(
      listingPrice,
      marketRange.minPrice,
      marketRange.maxPrice,
    );

    final (statusLabel, statusColor, statusIcon) = _getStatusStyle(status);
    final percentageFromAverage = marketRange.getPricePercentageFromAverage(listingPrice);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with status badge
          Container(
            padding: EdgeInsets.all(AppDimensions.padding),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Market Range',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: AppDimensions.gapSmall),
                    Text(
                      marketRange.category,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.gapMedium,
                    vertical: AppDimensions.gapSmall,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      SizedBox(width: AppDimensions.gapSmall),
                      Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Price range display
          Padding(
            padding: EdgeInsets.all(AppDimensions.padding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PriceColumn(
                      label: 'Min',
                      price: marketRange.minPrice,
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.trending_flat,
                          color: AppColors.secondary,
                          size: 18,
                        ),
                        SizedBox(height: AppDimensions.gapSmall),
                        Text(
                          'Range',
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    _PriceColumn(
                      label: 'Max',
                      price: marketRange.maxPrice,
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.padding),
                // Your price comparison
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.gapMedium,
                    vertical: AppDimensions.gapMedium,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Price',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: AppDimensions.gapSmall),
                          Text(
                            'PKR ${listingPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            percentageFromAverage > 0 ? '+$percentageFromAverage%' : '$percentageFromAverage%',
                            style: TextStyle(
                              color: percentageFromAverage > 0 ? AppColors.error : AppColors.success,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppDimensions.gapSmall),
                          Text(
                            percentageFromAverage > 0 ? 'Above Average' : 'Below Average',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppDimensions.gapMedium),
                // Insights text
                Text(
                  _getInsightText(status),
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (String, Color, IconData) _getStatusStyle(String status) {
    switch (status) {
      case 'great_deal':
        return ('Great Deal', AppColors.success, Icons.trending_down);
      case 'good_price':
        return ('Good Price', AppColors.success, Icons.check_circle);
      case 'fair_price':
        return ('Fair Price', AppColors.warning, Icons.info);
      case 'overpriced':
        return ('Overpriced', AppColors.error, Icons.warning);
      default:
        return ('Fair Price', AppColors.secondary, Icons.help);
    }
  }

  String _getInsightText(String status) {
    switch (status) {
      case 'great_deal':
        return 'This is an excellent price! Well below the current market range.';
      case 'good_price':
        return 'Good price for this device. Below the average market price.';
      case 'fair_price':
        return 'Fair price. Within the typical market range for this device.';
      case 'overpriced':
        return 'Price is above the typical market range. Consider negotiating.';
      default:
        return 'Compare this price with the market range above.';
    }
  }
}

class _PriceColumn extends StatelessWidget {
  final String label;
  final int price;

  const _PriceColumn({
    required this.label,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppDimensions.gapSmall),
        Text(
          'PKR ${price.toStringAsFixed(0)}',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
