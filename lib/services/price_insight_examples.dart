import 'price_insight_service.dart';

/// Example usage demonstrating the Smart Price Insight system
class PriceInsightExamples {
  static void runExamples() {
    print('=== Smart Price Insight Examples ===\n');

    // Example 1: Good price (within range)
    print('Example 1: Good Price');
    final goodPrice = PriceInsightService.analyzePriceInsight(
      listingPrice: 45000,
      historicalAveragePrice: 50000,
      marketMinPrice: 40000,
      marketMaxPrice: 60000,
    );
    print('Listing: Rs 45,000 | Average: Rs 50,000');
    print('Result: ${goodPrice.label}');
    print('Insight: ${goodPrice.insight}\n');

    // Example 2: Below market (great deal)
    print('Example 2: Below Market Deal');
    final belowMarket = PriceInsightService.analyzePriceInsight(
      listingPrice: 35000,
      historicalAveragePrice: 50000,
      marketMinPrice: 40000,
      marketMaxPrice: 60000,
    );
    print('Listing: Rs 35,000 | Average: Rs 50,000');
    print('Result: ${belowMarket.label}');
    print('Insight: ${belowMarket.insight}\n');

    // Example 3: High price (overpriced)
    print('Example 3: High Price');
    final highPrice = PriceInsightService.analyzePriceInsight(
      listingPrice: 58000,
      historicalAveragePrice: 50000,
      marketMinPrice: 40000,
      marketMaxPrice: 60000,
    );
    print('Listing: Rs 58,000 | Average: Rs 50,000');
    print('Result: ${highPrice.label}');
    print('Insight: ${highPrice.insight}\n');

    // Example 4: Percentage difference calculation
    print('Example 4: Percentage Difference');
    final priceDiff = PriceInsightService.calculatePercentageDifference(45000, 50000);
    print('Listing: Rs 45,000 vs Average: Rs 50,000');
    print('Difference: ${priceDiff.toStringAsFixed(1)}%\n');

    // Example 5: Market range check
    print('Example 5: Market Range Check');
    final inRange = PriceInsightService.isPriceWithinMarketRange(
      50000,
      40000,
      60000,
    );
    print('Price: Rs 50,000 | Range: Rs 40,000 - Rs 60,000');
    print('In Range: $inRange\n');
  }
}

/// Demonstrates thresholds:
/// - Good Price ✅: -15% to +10% from average
/// - High Price ⚠️: > +10% from average
/// - Below Market 🔥: <= -25% from average (great deal)
