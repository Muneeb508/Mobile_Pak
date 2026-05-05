import 'package:flutter/material.dart';
import '../../data/models/price_insight.dart';
import '../../services/price_insight_service.dart';

class PriceInsightWidget extends StatelessWidget {
  final int listingPrice;
  final int historicalAveragePrice;
  final int marketMinPrice;
  final int marketMaxPrice;
  final bool showDetails;

  const PriceInsightWidget({
    Key? key,
    required this.listingPrice,
    required this.historicalAveragePrice,
    required this.marketMinPrice,
    required this.marketMaxPrice,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insight = PriceInsightService.analyzePriceInsight(
      listingPrice: listingPrice,
      historicalAveragePrice: historicalAveragePrice,
      marketMinPrice: marketMinPrice,
      marketMaxPrice: marketMaxPrice,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: insight.color.withOpacity(0.1),
        border: Border.all(color: insight.color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(insight.icon, color: insight.color, size: 20),
              const SizedBox(width: 8),
              Text(
                insight.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: insight.color,
                ),
              ),
            ],
          ),
          if (showDetails) ...[
            const SizedBox(height: 8),
            Text(
              insight.insight,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
