import 'market_range_service.dart';

class MarketRangeExamples {
  static void runExamples() {
    print('=== Market Range Calculation Examples ===\n');

    // Example 1: iPhone 13 Pro listing analysis
    print('Example 1: iPhone 13 Pro Market Analysis');
    final iphonePrices = [
      85000, 87000, 90000, 88000, 92000,
      86000, 89000, 91000, 88000, 85000,
      90000, 89000, 87000, 88000, 86000,
      // Some outliers:
      15000, // very low (probably damaged)
      200000, // very high (might be different variant)
    ];

    final iPhoneRange = MarketRangeService.calculateMarketRange(iphonePrices);
    print('Total Listings: ${iphonePrices.length}');
    print('Valid Listings: ${iPhoneRange.validListingsCount}');
    print('Outliers Removed: ${iPhoneRange.outliers.length}');
    print('Market Range: ${iPhoneRange.formattedRange}');
    print('Average: Rs ${iPhoneRange.averagePrice}');
    print('Median: Rs ${iPhoneRange.medianPrice}');
    print('Price Spread: Rs ${iPhoneRange.priceSpread} (${iPhoneRange.spreadPercentage.toStringAsFixed(1)}%)\n');

    // Example 2: Budget phone analysis
    print('Example 2: Budget Phone Market Analysis');
    final budgetPrices = [
      14000, 15000, 16000, 14500, 15500,
      14800, 15200, 16200, 15800, 14200,
      15000, 15500, 14500, 16000, 15100,
      // Outliers:
      1000, // too low
      100000, // way too high
    ];

    final budgetRange = MarketRangeService.calculateMarketRange(budgetPrices);
    print('Total Listings: ${budgetPrices.length}');
    print('Valid Listings: ${budgetRange.validListingsCount}');
    print('Market Range: ${budgetRange.formattedRange}');
    print('Average: Rs ${budgetRange.averagePrice}');
    print('Standard Deviation: Rs ${MarketRangeService.getPriceStatistics(budgetPrices)['stdDev']}\n');

    // Example 3: Statistics comparison
    print('Example 3: Full Statistics');
    final stats = MarketRangeService.getPriceStatistics(iphonePrices);
    print('iPhone 13 Pro Price Statistics:');
    print('Count: ${stats['count']} listings');
    print('Valid Count: ${stats['validCount']} listings');
    print('Outlier Count: ${stats['outlierCount']} listings');
    print('Min: Rs ${stats['min']}');
    print('Max: Rs ${stats['max']}');
    print('Average: Rs ${stats['average']}');
    print('Median: Rs ${stats['median']}');
    print('Range: Rs ${stats['range']} (${stats['rangePercentage']}%)');
    print('Std Dev: Rs ${stats['stdDev']}\n');

    // Example 4: Using percentile-based method
    print('Example 4: Percentile-Based Analysis');
    final percentileRange = MarketRangeService.calculateMarketRangeWithPercentiles(
      iphonePrices,
      lowerPercentile: 0.05,
      upperPercentile: 0.95,
    );
    print('Ignoring top 5% and bottom 5%');
    print('Market Range: ${percentileRange.formattedRange}');
    print('Valid Listings: ${percentileRange.validListingsCount}\n');

    // Example 5: Check if price is outlier
    print('Example 5: Outlier Detection');
    final testRange = MarketRangeService.calculateMarketRange([
      50000, 51000, 52000, 53000, 54000,
    ]);
    print('Is Rs 51000 an outlier? ${MarketRangeService.isOutlier(51000, testRange)}');
    print('Is Rs 100000 an outlier? ${MarketRangeService.isOutlier(100000, testRange)}');
  }
}

/// Real-world usage patterns:
///
/// Pattern 1: Display market range on product detail
/// ```dart
/// final range = MarketRangeService.calculateMarketRange(
///   otherListings.map((p) => p.price).toList(),
/// );
/// print('Market range: ${range.formattedRange}');
/// ```
///
/// Pattern 2: Check if listing is competitive
/// ```dart
/// final range = MarketRangeService.calculateMarketRange(prices);
/// final isCompetitive = listingPrice >= range.minPrice &&
///                       listingPrice <= range.maxPrice;
/// ```
///
/// Pattern 3: Get full market statistics
/// ```dart
/// final stats = MarketRangeService.getPriceStatistics(prices);
/// print('Average price: Rs ${stats['average']}');
/// print('Market health: ${stats['rangePercentage']}%');
/// ```
