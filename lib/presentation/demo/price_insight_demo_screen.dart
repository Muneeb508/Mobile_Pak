import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/price_insight_service.dart';
import '../shared/price_insight_widget.dart';

class PriceInsightDemoScreen extends StatefulWidget {
  const PriceInsightDemoScreen({Key? key}) : super(key: key);

  @override
  State<PriceInsightDemoScreen> createState() => _PriceInsightDemoScreenState();
}

class _PriceInsightDemoScreenState extends State<PriceInsightDemoScreen> {
  int _selectedExample = 0;

  final List<DemoCase> _demoCases = [
    DemoCase(
      title: 'Good Price Example',
      description: 'Price is within the acceptable range',
      listingPrice: 45000,
      averagePrice: 50000,
      minPrice: 40000,
      maxPrice: 60000,
    ),
    DemoCase(
      title: 'Below Market Deal',
      description: 'Significantly lower than average - great bargain!',
      listingPrice: 35000,
      averagePrice: 50000,
      minPrice: 30000,
      maxPrice: 60000,
    ),
    DemoCase(
      title: 'High Price',
      description: 'Price is above the market average',
      listingPrice: 58000,
      averagePrice: 50000,
      minPrice: 40000,
      maxPrice: 60000,
    ),
    DemoCase(
      title: 'Real iPhone 13 Pro Example',
      description: 'Market analysis for used iPhone 13 Pro',
      listingPrice: 85000,
      averagePrice: 100000,
      minPrice: 80000,
      maxPrice: 120000,
    ),
    DemoCase(
      title: 'Edge Case: Exactly at Upper Bound',
      description: 'Testing boundary condition (+10%)',
      listingPrice: 55000,
      averagePrice: 50000,
      minPrice: 40000,
      maxPrice: 60000,
    ),
    DemoCase(
      title: 'Edge Case: Just Above Upper Bound',
      description: 'Testing threshold transition (+11%)',
      listingPrice: 55500,
      averagePrice: 50000,
      minPrice: 40000,
      maxPrice: 60000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final currentCase = _demoCases[_selectedExample];
    final percentDiff = PriceInsightService.calculatePercentageDifference(
      currentCase.listingPrice,
      currentCase.averagePrice,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Insight Demo'),
        backgroundColor: AppColors.accent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Example selector
              Text(
                'Select Demo Case',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _demoCases.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedExample;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedExample = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.accent
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Case ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentCase.title.split(' ').first,
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white : Colors.grey,
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

              // Case details
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentCase.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentCase.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Price metrics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    _PriceMetricRow(
                      label: 'Listing Price',
                      value: 'Rs ${currentCase.listingPrice.toString().replaceAllMapped(
                            RegExp(r'\B(?=(\d{3})+(?!\d))'),
                            (match) => ',',
                          )}',
                    ),
                    const SizedBox(height: 12),
                    _PriceMetricRow(
                      label: 'Average Price',
                      value: 'Rs ${currentCase.averagePrice.toString().replaceAllMapped(
                            RegExp(r'\B(?=(\d{3})+(?!\d))'),
                            (match) => ',',
                          )}',
                    ),
                    const SizedBox(height: 12),
                    _PriceMetricRow(
                      label: 'Market Range',
                      value:
                          'Rs ${currentCase.minPrice} - Rs ${currentCase.maxPrice}',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Difference: ${percentDiff.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Price insight widget
              Text(
                'Price Insight Result',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              PriceInsightWidget(
                listingPrice: currentCase.listingPrice,
                historicalAveragePrice: currentCase.averagePrice,
                marketMinPrice: currentCase.minPrice,
                marketMaxPrice: currentCase.maxPrice,
                showDetails: true,
              ),
              const SizedBox(height: 24),

              // Threshold explanation
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Threshold Explanation',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '✅ Good Price: -15% to +10% from average',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '⚠️ High Price: > +10% from average',
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '🔥 Below Market: ≤ -25% from average',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceMetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceMetricRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class DemoCase {
  final String title;
  final String description;
  final int listingPrice;
  final int averagePrice;
  final int minPrice;
  final int maxPrice;

  DemoCase({
    required this.title,
    required this.description,
    required this.listingPrice,
    required this.averagePrice,
    required this.minPrice,
    required this.maxPrice,
  });
}
