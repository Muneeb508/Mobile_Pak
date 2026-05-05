import 'dart:math';

class PriceEstimate {
  final int minPrice;
  final int maxPrice;
  final int avgPrice;
  final int validListingsCount;
  final List<int> removedOutliers;

  PriceEstimate({
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
    required this.validListingsCount,
    required this.removedOutliers,
  });

  int get priceRange => maxPrice - minPrice;

  String get label {
    if (avgPrice == 0) return 'Insufficient data';
    return 'PKR $minPrice – PKR $maxPrice';
  }

  /// Get price insight label
  String getPriceInsight(int listingPrice) {
    if (avgPrice == 0) return '';

    final percentageDiff = ((listingPrice - avgPrice) / avgPrice) * 100;

    if (percentageDiff <= -25) {
      return '🔥 Below market';
    } else if (percentageDiff > 10) {
      return '⚠️ High price';
    } else {
      return '✅ Good price';
    }
  }
}

class PriceEstimatorService {
  /// Calculate market price estimate with outlier filtering
  ///
  /// Uses ±20% filtering method for simplicity
  /// Removes prices that deviate more than 20% from median
  static PriceEstimate calculatePriceEstimate(List<int> prices) {
    if (prices.isEmpty) {
      return PriceEstimate(
        minPrice: 0,
        maxPrice: 0,
        avgPrice: 0,
        validListingsCount: 0,
        removedOutliers: [],
      );
    }

    if (prices.length == 1) {
      return PriceEstimate(
        minPrice: prices[0],
        maxPrice: prices[0],
        avgPrice: prices[0],
        validListingsCount: 1,
        removedOutliers: [],
      );
    }

    // Sort for median calculation
    final sorted = List<int>.from(prices)..sort();
    final median = sorted.length.isOdd
        ? sorted[sorted.length ~/ 2]
        : (sorted[sorted.length ~/ 2 - 1] + sorted[sorted.length ~/ 2]) ~/ 2;

    // Calculate outlier bounds (±20% from median)
    final lowerBound = (median * 0.8).toInt();
    final upperBound = (median * 1.2).toInt();

    // Separate valid prices and outliers
    final validPrices = <int>[];
    final outliers = <int>[];

    for (final price in prices) {
      if (price >= lowerBound && price <= upperBound) {
        validPrices.add(price);
      } else {
        outliers.add(price);
      }
    }

    // Use valid prices if available, otherwise use all
    final pricesForCalculation = validPrices.isEmpty ? sorted : validPrices;

    final minPrice = pricesForCalculation.reduce((a, b) => a < b ? a : b);
    final maxPrice = pricesForCalculation.reduce((a, b) => a > b ? a : b);
    final avgPrice = (pricesForCalculation.reduce((a, b) => a + b) /
            pricesForCalculation.length)
        .round();

    return PriceEstimate(
      minPrice: minPrice,
      maxPrice: maxPrice,
      avgPrice: avgPrice,
      validListingsCount: pricesForCalculation.length,
      removedOutliers: outliers,
    );
  }

  /// Format price with commas
  static String formatPrice(int price) {
    return 'PKR ${price.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    )}';
  }

  /// Check if listing price is good, high, or below market
  static String getPriceLabel(int listingPrice, int avgPrice) {
    if (avgPrice == 0) return '';

    final percentageDiff = ((listingPrice - avgPrice) / avgPrice) * 100;

    if (percentageDiff <= -25) {
      return '🔥 Below market';
    } else if (percentageDiff > 10) {
      return '⚠️ High price';
    } else {
      return '✅ Good price';
    }
  }
}
