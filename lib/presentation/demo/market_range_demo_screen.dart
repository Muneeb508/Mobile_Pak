import 'package:flutter/material.dart';
import '../../services/market_range_service.dart';
import '../shared/market_range_widget.dart';

class MarketRangeDemoScreen extends StatefulWidget {
  const MarketRangeDemoScreen({Key? key}) : super(key: key);

  @override
  State<MarketRangeDemoScreen> createState() => _MarketRangeDemoScreenState();
}

class _MarketRangeDemoScreenState extends State<MarketRangeDemoScreen> {
  int _selectedExample = 0;

  final List<MarketRangeExample> _examples = [
    MarketRangeExample(
      title: 'iPhone 13 Pro',
      description: 'Market analysis with outliers',
      prices: [
        85000, 87000, 90000, 88000, 92000,
        86000, 89000, 91000, 88000, 85000,
        90000, 89000, 87000, 88000, 86000,
        15000, // outlier
        200000, // outlier
      ],
    ),
    MarketRangeExample(
      title: 'Samsung Galaxy A12',
      description: 'Budget phone market',
      prices: [
        14000, 15000, 16000, 14500, 15500,
        14800, 15200, 16200, 15800, 14200,
        15000, 15500, 14500, 16000, 15100,
        1000, // outlier
        100000, // outlier
      ],
    ),
    MarketRangeExample(
      title: 'OnePlus 9',
      description: 'Consistent market prices',
      prices: [
        35000, 36000, 37000, 35500, 36500,
        35800, 36200, 37200, 36800, 35300,
        36500, 36000, 35500, 37000, 36300,
      ],
    ),
    MarketRangeExample(
      title: 'iPhone 14 Pro Max',
      description: 'High-end device with few outliers',
      prices: [
        180000, 185000, 190000, 187000, 192000,
        186000, 189000, 191000, 188000, 185000,
        190000, 189000, 187000, 188000, 186000,
        50000, // outlier - probably damaged
        300000, // outlier - premium variant?
      ],
    ),
    MarketRangeExample(
      title: 'Used Android Mix',
      description: 'Diverse phone models with high variance',
      prices: [
        20000, 25000, 30000, 35000, 40000,
        22000, 28000, 32000, 38000, 42000,
        24000, 29000, 31000, 39000, 41000,
        2000, // very low
        500000, // very high
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final example = _examples[_selectedExample];
    final range = MarketRangeService.calculateMarketRange(example.prices);
    final stats = MarketRangeService.getPriceStatistics(example.prices);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Range Demo'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Example selector
              Text(
                'Select Device',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _examples.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedExample;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedExample = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(minWidth: 90),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[700] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _examples[index].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_examples[index].prices.length}',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.white70 : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Title and description
              Text(
                example.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                example.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(height: 16),

              // Market range widget
              MarketRangeWidget(
                prices: example.prices,
                productModel: example.title,
                showDetails: true,
                showStatistics: true,
              ),
              const SizedBox(height: 24),

              // Detailed statistics
              _buildStatisticsCard(context, stats, range),
              const SizedBox(height: 24),

              // Outliers list
              if (range.outliers.isNotEmpty) _buildOutliersCard(range),
              const SizedBox(height: 24),

              // Price comparison
              _buildPriceComparisonChart(range),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(
    BuildContext context,
    Map<String, dynamic> stats,
    dynamic range,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detailed Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Total Listings', '${stats['count']}'),
            _buildStatRow('Valid Listings', '${stats['validCount']}'),
            _buildStatRow('Outliers Detected', '${stats['outlierCount']}'),
            const Divider(height: 16),
            _buildStatRow('Minimum Price', 'Rs ${stats['min']}'),
            _buildStatRow('Maximum Price', 'Rs ${stats['max']}'),
            _buildStatRow('Average Price', 'Rs ${stats['average']}'),
            _buildStatRow('Median Price', 'Rs ${stats['median']}'),
            const Divider(height: 16),
            _buildStatRow('Price Range', 'Rs ${stats['range']}'),
            _buildStatRow('Range %', '${stats['rangePercentage']}%'),
            _buildStatRow('Std Deviation', 'Rs ${stats['stdDev']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildOutliersCard(dynamic range) {
    return Card(
      color: Colors.orange[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange[700]),
                const SizedBox(width: 8),
                Text(
                  'Outliers Detected (${range.outliers.length})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: range.outliers.map<Widget>((outlier) {
                return Chip(
                  label: Text('Rs $outlier'),
                  backgroundColor: Colors.orange[200],
                  labelStyle: TextStyle(color: Colors.orange[900]),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Text(
              'These values were excluded from the market range calculation using the IQR method.',
              style: TextStyle(fontSize: 11, color: Colors.orange[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceComparisonChart(dynamic range) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceBar('Min', range.minPrice, range.maxPrice),
                  const SizedBox(height: 12),
                  _buildPriceBar('Average', range.averagePrice, range.maxPrice),
                  const SizedBox(height: 12),
                  _buildPriceBar('Median', range.medianPrice, range.maxPrice),
                  const SizedBox(height: 12),
                  _buildPriceBar('Max', range.maxPrice, range.maxPrice),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBar(String label, int value, int maxValue) {
    final percentage = (value / maxValue) * 100;
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label)),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 24,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.blue[700]),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            'Rs $value',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class MarketRangeExample {
  final String title;
  final String description;
  final List<int> prices;

  MarketRangeExample({
    required this.title,
    required this.description,
    required this.prices,
  });
}
