import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/price_estimator_service.dart';
import '../../../data/models/product_model.dart';

class PriceEstimatorSheet extends StatefulWidget {
  final Product product;

  const PriceEstimatorSheet({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<PriceEstimatorSheet> createState() => _PriceEstimatorSheetState();
}

class _PriceEstimatorSheetState extends State<PriceEstimatorSheet> {
  late Future<PriceEstimate> _estimateFuture;

  @override
  void initState() {
    super.initState();
    _estimateFuture = _fetchAndCalculatePrices();
  }

  Future<PriceEstimate> _fetchAndCalculatePrices() async {
    try {
      // Query similar listings (same model/title)
      final query = FirebaseFirestore.instance
          .collection('products')
          .where('title', isEqualTo: widget.product.title)
          .where('condition', isEqualTo: widget.product.condition)
          .limit(50); // Fetch up to 50 similar listings

      final snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        return PriceEstimate(
          minPrice: 0,
          maxPrice: 0,
          avgPrice: 0,
          validListingsCount: 0,
          removedOutliers: [],
        );
      }

      // Extract prices
      final prices = snapshot.docs
          .map((doc) => (doc['priceValue'] as int))
          .toList();

      // Calculate estimate
      return PriceEstimatorService.calculatePriceEstimate(prices);
    } catch (e) {
      print('Error fetching prices: $e');
      return PriceEstimate(
        minPrice: 0,
        maxPrice: 0,
        avgPrice: 0,
        validListingsCount: 0,
        removedOutliers: [],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PriceEstimate>(
      future: _estimateFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingSheet();
        }

        if (snapshot.hasError) {
          return _buildErrorSheet();
        }

        final estimate = snapshot.data!;

        if (estimate.validListingsCount == 0) {
          return _buildNoDataSheet();
        }

        return _buildEstimateSheet(context, estimate);
      },
    );
  }

  Widget _buildLoadingSheet() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text(
            'Analyzing market prices...',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSheet() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.red[400]),
          const SizedBox(height: 16),
          const Text(
            'Unable to fetch market data',
            style: TextStyle(fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataSheet() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No similar listings found for "${widget.product.title}"',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Add more listings to see price estimates',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimateSheet(BuildContext context, PriceEstimate estimate) {
    final priceLabel = PriceEstimatorService.getPriceLabel(
      widget.product.priceValue,
      estimate.avgPrice,
    );

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Text(
                  'Market Price Estimator',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main estimate box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue[200]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Market Range',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    estimate.label,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Price details
            Row(
              children: [
                Expanded(
                  child: _buildPriceCard(
                    'Minimum',
                    PriceEstimatorService.formatPrice(estimate.minPrice),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPriceCard(
                    'Average',
                    PriceEstimatorService.formatPrice(estimate.avgPrice),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPriceCard(
                    'Maximum',
                    PriceEstimatorService.formatPrice(estimate.maxPrice),
                    Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Your price analysis
            if (priceLabel.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: priceLabel.contains('Good')
                      ? Colors.green[50]
                      : priceLabel.contains('High')
                          ? Colors.orange[50]
                          : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: priceLabel.contains('Good')
                        ? Colors.green[200]!
                        : priceLabel.contains('High')
                            ? Colors.orange[200]!
                            : Colors.red[200]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          PriceEstimatorService.formatPrice(
                            widget.product.priceValue,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          priceLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Data info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Based on ${estimate.validListingsCount} listings${estimate.removedOutliers.isNotEmpty ? ' (${estimate.removedOutliers.length} outliers removed)' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(String label, String price, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
