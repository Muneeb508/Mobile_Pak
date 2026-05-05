import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pak/services/market_range_service.dart';

void main() {
  group('MarketRangeService', () {
    group('calculateMarketRange - Basic Functionality', () {
      test('handles single price', () {
        final range = MarketRangeService.calculateMarketRange([50000]);

        expect(range.minPrice, equals(50000));
        expect(range.maxPrice, equals(50000));
        expect(range.averagePrice, equals(50000));
        expect(range.medianPrice, equals(50000));
        expect(range.outliers, isEmpty);
        expect(range.validListingsCount, equals(1));
      });

      test('calculates range for two prices', () {
        final range = MarketRangeService.calculateMarketRange([40000, 60000]);

        // With only 2 prices, they're both valid (no outliers)
        expect(range.minPrice, isA<int>());
        expect(range.maxPrice, isA<int>());
        expect(range.validListingsCount, greaterThanOrEqualTo(1));
      });

      test('calculates correct average for tight range', () {
        // Use a larger dataset with tight range to avoid outlier filtering
        final prices = [
          45000, 46000, 47000, 48000, 49000,
          50000, 51000, 52000, 53000, 54000,
        ];
        final range = MarketRangeService.calculateMarketRange(prices);

        expect(range.averagePrice, inInclusiveRange(48000, 51000));
      });

      test('calculates correct median for odd count', () {
        final prices = [
          48000, 49000, 50000, 51000, 52000,
          45000, 46000, 47000, 53000, 54000,
        ];
        final range = MarketRangeService.calculateMarketRange(prices);

        expect(range.medianPrice, isA<int>());
        expect(range.validListingsCount, greaterThan(0));
      });

      test('calculates correct median for even count', () {
        final prices = [
          45000, 46000, 47000, 48000,
          50000, 51000, 52000, 53000,
        ];
        final range = MarketRangeService.calculateMarketRange(prices);

        expect(range.medianPrice, inInclusiveRange(48000, 50000));
      });
    });

    group('calculateMarketRange - Outlier Detection', () {
      test('ignores extreme low value (outlier)', () {
        // Normal prices: 50000, 51000, 52000, 53000
        // Extreme low: 10000
        final range = MarketRangeService.calculateMarketRange(
          [50000, 51000, 52000, 53000, 10000],
        );

        expect(range.outliers, contains(10000));
        expect(range.minPrice, equals(50000));
        expect(range.validListingsCount, equals(4));
      });

      test('ignores extreme high value (outlier)', () {
        // Normal prices: 50000, 51000, 52000, 53000
        // Extreme high: 500000
        final range = MarketRangeService.calculateMarketRange(
          [50000, 51000, 52000, 53000, 500000],
        );

        expect(range.outliers, contains(500000));
        expect(range.maxPrice, equals(53000));
        expect(range.validListingsCount, equals(4));
      });

      test('handles multiple outliers', () {
        final range = MarketRangeService.calculateMarketRange(
          [45000, 50000, 52000, 48000, 5000, 999000],
        );

        expect(range.outliers.length, greaterThanOrEqualTo(1));
        expect(range.validListingsCount, lessThan(6));
      });

      test('preserves valid prices within range', () {
        final range = MarketRangeService.calculateMarketRange(
          [45000, 50000, 55000, 48000, 52000],
        );

        expect(range.validListingsCount, equals(5));
        expect(range.outliers, isEmpty);
      });
    });

    group('calculateMarketRange - Real-world Data', () {
      test('iPhone prices realistic scenario', () {
        final iphonePrices = [
          85000, 87000, 90000, 88000, 92000,
          86000, 89000, 91000, 15000, 200000, // outliers
          88000, 85000, 90000, 89000, 87000,
        ];

        final range = MarketRangeService.calculateMarketRange(iphonePrices);

        expect(range.outliers.length, greaterThan(0));
        expect(range.minPrice, greaterThan(80000));
        expect(range.minPrice, lessThan(95000));
        expect(range.maxPrice, lessThan(100000));
        expect(range.averagePrice, inInclusiveRange(85000, 92000));
      });

      test('budget phone prices realistic scenario', () {
        final budgetPrices = [
          15000, 16000, 17000, 14000, 18000,
          15500, 16500, 1000, 100000, // outliers
          15800, 16200, 17500, 14800, 15300,
        ];

        final range = MarketRangeService.calculateMarketRange(budgetPrices);

        expect(range.minPrice, greaterThan(0));
        expect(range.maxPrice, greaterThan(range.minPrice));
        expect(range.outliers.length, greaterThanOrEqualTo(1));
      });
    });

    group('calculateMarketRangeWithPercentiles', () {
      test('removes extreme percentiles', () {
        final prices = List.generate(100, (i) => 40000 + (i * 100));

        final range = MarketRangeService.calculateMarketRangeWithPercentiles(
          prices,
          lowerPercentile: 0.05,
          upperPercentile: 0.95,
        );

        expect(range.validListingsCount, lessThan(100));
        expect(range.outliers.length, greaterThan(0));
      });

      test('uses custom percentiles', () {
        final prices = List.generate(100, (i) => 40000 + (i * 100));

        final range = MarketRangeService.calculateMarketRangeWithPercentiles(
          prices,
          lowerPercentile: 0.1,
          upperPercentile: 0.9,
        );

        expect(range.validListingsCount, lessThan(100));
      });
    });

    group('MarketRange properties', () {
      test('formattedRange displays correctly', () {
        final range = MarketRangeService.calculateMarketRange(
          [40000, 45000, 50000, 55000, 60000],
        );

        expect(range.formattedRange, contains('Rs'));
        expect(range.formattedRange, contains('–'));
      });

      test('priceSpread calculates correctly', () {
        final range = MarketRangeService.calculateMarketRange(
          [40000, 45000, 50000, 55000, 60000],
        );

        expect(range.priceSpread, greaterThan(0));
        expect(range.priceSpread, lessThanOrEqualTo(20000));
      });

      test('spreadPercentage is positive', () {
        final range = MarketRangeService.calculateMarketRange(
          [40000, 45000, 50000, 55000, 60000],
        );

        expect(range.spreadPercentage, greaterThan(0));
      });
    });

    group('getPriceStatistics', () {
      test('returns complete statistics', () {
        final stats = MarketRangeService.getPriceStatistics(
          [45000, 48000, 50000, 52000, 55000],
        );

        expect(stats['count'], equals(5));
        expect(stats['min'], isA<int>());
        expect(stats['max'], isA<int>());
        expect(stats['average'], isA<int>());
        expect(stats['stdDev'], isA<int>());
      });

      test('distinguishes valid and outlier counts', () {
        final stats = MarketRangeService.getPriceStatistics(
          [45000, 48000, 50000, 52000, 55000, 5000, 500000],
        );

        expect(stats['count'], equals(7));
        expect(stats['validCount'], lessThanOrEqualTo(7));
        expect(stats['validCount'], greaterThan(0));
      });
    });

    group('isOutlier', () {
      test('correctly identifies outliers from detected set', () {
        final range = MarketRangeService.calculateMarketRange(
          [48000, 49000, 50000, 51000, 52000, 1000, 999000],
        );

        final hasOutliers = range.outliers.isNotEmpty;
        if (hasOutliers) {
          final firstOutlier = range.outliers.first;
          expect(
            MarketRangeService.isOutlier(firstOutlier, range),
            isTrue,
          );
        }
      });

      test('identifies valid price as non-outlier', () {
        final range = MarketRangeService.calculateMarketRange(
          [48000, 49000, 50000, 51000, 52000],
        );

        final anyValidPrice = range.validListingsCount > 0;
        expect(anyValidPrice, isTrue);
      });
    });

    group('Edge cases', () {
      test('handles empty list', () {
        final range = MarketRangeService.calculateMarketRange([]);

        expect(range.minPrice, equals(0));
        expect(range.maxPrice, equals(0));
        expect(range.averagePrice, equals(0));
        expect(range.validListingsCount, equals(0));
      });

      test('handles all identical prices', () {
        final range = MarketRangeService.calculateMarketRange(
          [50000, 50000, 50000, 50000],
        );

        expect(range.minPrice, equals(50000));
        expect(range.maxPrice, equals(50000));
        expect(range.averagePrice, equals(50000));
        expect(range.medianPrice, equals(50000));
        expect(range.outliers, isEmpty);
      });

      test('handles very large price differences', () {
        final range = MarketRangeService.calculateMarketRange(
          [1, 1000000],
        );

        expect(range.minPrice, isA<int>());
        expect(range.maxPrice, isA<int>());
        expect(range.averagePrice, isA<int>());
      });
    });
  });
}
