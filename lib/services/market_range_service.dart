import 'dart:math';
import '../data/models/market_range.dart';

class MarketRangeService {
  /// Calculates market price range with outlier detection using IQR method
  ///
  /// Outliers are defined as values outside Q1 - 1.5*IQR to Q3 + 1.5*IQR
  /// This removes extreme values for more accurate market analysis
  static MarketRange calculateMarketRange(List<int> prices) {
    if (prices.isEmpty) {
      return _emptyRange();
    }

    if (prices.length == 1) {
      final price = prices.first;
      return MarketRange(
        minPrice: price,
        maxPrice: price,
        averagePrice: price,
        medianPrice: price,
        outliers: [],
        validListingsCount: 1,
      );
    }

    // Sort prices for percentile calculations
    final sortedPrices = List<int>.from(prices)..sort();

    // Calculate quartiles
    final q1 = _calculateQuartile(sortedPrices, 0.25);
    final q3 = _calculateQuartile(sortedPrices, 0.75);
    final iqr = q3 - q1;

    // Define outlier bounds (IQR method)
    final lowerBound = q1 - (1.5 * iqr).toInt();
    final upperBound = q3 + (1.5 * iqr).toInt();

    // Filter outliers
    final outliers = <int>[];
    final validPrices = <int>[];

    for (final price in prices) {
      if (price < lowerBound || price > upperBound) {
        outliers.add(price);
      } else {
        validPrices.add(price);
      }
    }

    // If all prices were filtered, use original list
    final pricesForCalculation = validPrices.isEmpty ? sortedPrices : validPrices;
    pricesForCalculation.sort();

    final minPrice = pricesForCalculation.first;
    final maxPrice = pricesForCalculation.last;
    final averagePrice = (pricesForCalculation.reduce((a, b) => a + b) /
            pricesForCalculation.length)
        .round();
    final medianPrice = _calculateMedian(pricesForCalculation);

    return MarketRange(
      minPrice: minPrice,
      maxPrice: maxPrice,
      averagePrice: averagePrice,
      medianPrice: medianPrice,
      outliers: outliers,
      validListingsCount: pricesForCalculation.length,
    );
  }

  /// Alternative method: Simple percentile-based outlier removal
  /// Ignores top 5% and bottom 5% of prices
  static MarketRange calculateMarketRangeWithPercentiles(
    List<int> prices, {
    double lowerPercentile = 0.05,
    double upperPercentile = 0.95,
  }) {
    if (prices.isEmpty) {
      return _emptyRange();
    }

    if (prices.length == 1) {
      final price = prices.first;
      return MarketRange(
        minPrice: price,
        maxPrice: price,
        averagePrice: price,
        medianPrice: price,
        outliers: [],
        validListingsCount: 1,
      );
    }

    final sortedPrices = List<int>.from(prices)..sort();

    // Calculate percentile indices
    final lowerIndex = ((sortedPrices.length - 1) * lowerPercentile).toInt();
    final upperIndex = ((sortedPrices.length - 1) * upperPercentile).toInt();

    // Get valid range
    final validMin = sortedPrices[lowerIndex];
    final validMax = sortedPrices[upperIndex];

    // Separate outliers
    final outliers = <int>[];
    final validPrices = <int>[];

    for (final price in prices) {
      if (price < validMin || price > validMax) {
        outliers.add(price);
      } else {
        validPrices.add(price);
      }
    }

    final minPrice = validPrices.isEmpty ? sortedPrices.first : validMin;
    final maxPrice = validPrices.isEmpty ? sortedPrices.last : validMax;
    final pricesForCalc = validPrices.isEmpty ? sortedPrices : validPrices;

    final averagePrice = (pricesForCalc.reduce((a, b) => a + b) /
            pricesForCalc.length)
        .round();
    final medianPrice = _calculateMedian(pricesForCalc);

    return MarketRange(
      minPrice: minPrice,
      maxPrice: maxPrice,
      averagePrice: averagePrice,
      medianPrice: medianPrice,
      outliers: outliers,
      validListingsCount: pricesForCalc.length,
    );
  }

  /// Calculate quartile value at given percentile
  static int _calculateQuartile(List<int> sortedPrices, double percentile) {
    final index = ((sortedPrices.length - 1) * percentile).toInt();
    return sortedPrices[index];
  }

  /// Calculate median value
  static int _calculateMedian(List<int> sortedPrices) {
    if (sortedPrices.isEmpty) return 0;

    if (sortedPrices.length.isOdd) {
      return sortedPrices[sortedPrices.length ~/ 2];
    } else {
      final mid = sortedPrices.length ~/ 2;
      return ((sortedPrices[mid - 1] + sortedPrices[mid]) / 2).toInt();
    }
  }

  /// Check if a price is an outlier based on IQR method
  static bool isOutlier(int price, MarketRange range) {
    return range.outliers.contains(price);
  }

  /// Get price statistics for analysis
  static Map<String, dynamic> getPriceStatistics(List<int> prices) {
    if (prices.isEmpty) {
      return {
        'count': 0,
        'min': 0,
        'max': 0,
        'average': 0,
        'median': 0,
        'stdDev': 0,
      };
    }

    final range = calculateMarketRange(prices);
    final validPrices = prices
        .where((p) => !range.outliers.contains(p))
        .toList();

    // Calculate standard deviation
    final average = validPrices.isEmpty
        ? 0
        : (validPrices.reduce((a, b) => a + b) / validPrices.length);

    final variance = validPrices.isEmpty
        ? 0
        : validPrices
            .map((p) => (p - average) * (p - average))
            .reduce((a, b) => a + b) /
            validPrices.length;

    final stdDev = (variance.isFinite ? sqrt(variance) : 0).toInt();

    return {
      'count': prices.length,
      'validCount': validPrices.length,
      'outlierCount': range.outliers.length,
      'min': range.minPrice,
      'max': range.maxPrice,
      'average': range.averagePrice,
      'median': range.medianPrice,
      'range': range.priceSpread,
      'rangePercentage': range.spreadPercentage.toStringAsFixed(1),
      'stdDev': stdDev,
    };
  }

  static MarketRange _emptyRange() {
    return MarketRange(
      minPrice: 0,
      maxPrice: 0,
      averagePrice: 0,
      medianPrice: 0,
      outliers: [],
      validListingsCount: 0,
    );
  }
}
