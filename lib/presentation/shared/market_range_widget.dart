import 'package:flutter/material.dart';
import '../../data/models/market_range.dart';
import '../../services/market_range_service.dart';

class MarketRangeWidget extends StatelessWidget {
  final List<int> prices;
  final String? productModel;
  final bool showDetails;
  final bool showStatistics;

  const MarketRangeWidget({
    Key? key,
    required this.prices,
    this.productModel,
    this.showDetails = true,
    this.showStatistics = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final range = MarketRangeService.calculateMarketRange(prices);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (productModel != null) ...[
            Text(
              productModel!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market range:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                range.formattedRange,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          if (showDetails) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('Average', range.averagePrice),
                _buildStatItem('Median', range.medianPrice),
                _buildStatItem('Listings', range.validListingsCount),
              ],
            ),
          ],
          if (showStatistics) ...[
            const SizedBox(height: 12),
            _buildStatisticsSection(context, range),
          ],
          if (range.outliers.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.orange[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${range.outliers.length} outlier${range.outliers.length > 1 ? 's' : ''} ignored in range calculation',
                      style: TextStyle(fontSize: 11, color: Colors.orange[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value >= 1000 ? 'Rs ${value.toString().replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                (match) => ',',
              )}' : value.toString(),
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection(BuildContext context, MarketRange range) {
    final stats = MarketRangeService.getPriceStatistics(prices);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Statistics',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          'Price Spread',
          'Rs ${range.priceSpread.toString().replaceAllMapped(
            RegExp(r'\B(?=(\d{3})+(?!\d))'),
            (match) => ',',
          )} (${range.spreadPercentage.toStringAsFixed(1)}%)',
        ),
        _buildStatRow(
          'Standard Deviation',
          'Rs ${stats['stdDev']}',
        ),
        _buildStatRow(
          'Outliers Removed',
          '${range.outliers.length} values',
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
