import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../data/models/price_insight.dart';

class PriceInsightService {
  /// Thresholds for price comparison (as percentages)
  static const double _goodPriceLowerBound = -15; // 15% below average
  static const double _goodPriceUpperBound = 10; // 10% above average
  static const double _bellowMarketThreshold = -25; // 25% below average is "Below market"

  /// Calculates price insight based on listing price and market data
  ///
  /// Parameters:
  /// - [listingPrice]: The price of the current listing
  /// - [historicalAveragePrice]: The historical average price for the same model
  /// - [marketMinPrice]: The minimum price in the current market
  /// - [marketMaxPrice]: The maximum price in the current market
  ///
  /// Returns a [PriceInsight] object with label, color, icon, and detailed insight
  static PriceInsight analyzePriceInsight({
    required int listingPrice,
    required int historicalAveragePrice,
    required int marketMinPrice,
    required int marketMaxPrice,
  }) {
    if (historicalAveragePrice <= 0) {
      return _unknownInsight();
    }

    final percentageFromAverage = ((listingPrice - historicalAveragePrice) / historicalAveragePrice) * 100;

    // Below market: significantly lower than average (≤25% below)
    if (percentageFromAverage <= _bellowMarketThreshold) {
      return PriceInsight(
        label: 'Below market 🔥',
        color: const Color(0xFFFF6B35), // Orange
        icon: Icons.flash_on,
        insight: 'This is ${percentageFromAverage.abs().toStringAsFixed(0)}% below average - great deal!',
      );
    }

    // High price: above the good range (>10% above average)
    if (percentageFromAverage > _goodPriceUpperBound) {
      return PriceInsight(
        label: 'High price ⚠️',
        color: const Color(0xFFF77F00), // Warning orange
        icon: Icons.warning_amber,
        insight: 'This is ${percentageFromAverage.toStringAsFixed(0)}% above average',
      );
    }

    // Good price: within the acceptable range (-15% to +10%)
    return PriceInsight(
      label: 'Good price ✅',
      color: AppColors.accent, // Green
      icon: Icons.check_circle,
      insight: 'Fairly priced compared to market average',
    );
  }

  static PriceInsight _unknownInsight() {
    return PriceInsight(
      label: 'Unknown 📊',
      color: Colors.grey,
      icon: Icons.info_outline,
      insight: 'Not enough market data available',
    );
  }

  /// Calculates the percentage difference between listing and average price
  static double calculatePercentageDifference(int listingPrice, int averagePrice) {
    if (averagePrice <= 0) return 0;
    return ((listingPrice - averagePrice) / averagePrice) * 100;
  }

  /// Checks if the price is within market range
  static bool isPriceWithinMarketRange(int listingPrice, int minPrice, int maxPrice) {
    return listingPrice >= minPrice && listingPrice <= maxPrice;
  }
}
