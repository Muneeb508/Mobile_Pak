import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pak/services/price_estimator_service.dart';

void main() {
  group('PriceEstimatorService', () {
    group('calculatePriceEstimate', () {
      test('handles empty list', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate([]);

        expect(estimate.minPrice, equals(0));
        expect(estimate.maxPrice, equals(0));
        expect(estimate.avgPrice, equals(0));
        expect(estimate.validListingsCount, equals(0));
      });

      test('handles single price', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate([50000]);

        expect(estimate.minPrice, equals(50000));
        expect(estimate.maxPrice, equals(50000));
        expect(estimate.avgPrice, equals(50000));
        expect(estimate.validListingsCount, equals(1));
      });

      test('calculates correct average', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [40000, 50000, 60000],
        );

        expect(estimate.avgPrice, equals(50000));
      });

      test('identifies outliers using ±20% filter', () {
        // Median = 50000
        // Bounds: 40000-60000
        // 30000 and 70000 should be outliers
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [45000, 50000, 55000, 30000, 70000],
        );

        expect(estimate.removedOutliers.length, equals(2));
        expect(estimate.validListingsCount, equals(3));
      });

      test('filters extreme low values', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [48000, 49000, 50000, 51000, 52000, 5000],
        );

        expect(estimate.removedOutliers, contains(5000));
        expect(estimate.minPrice, equals(48000));
      });

      test('filters extreme high values', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [48000, 49000, 50000, 51000, 52000, 500000],
        );

        expect(estimate.removedOutliers, contains(500000));
        expect(estimate.maxPrice, equals(52000));
      });

      test('calculates correct price range', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [40000, 50000, 60000],
        );

        expect(estimate.priceRange, equals(20000));
      });

      test('formats price range correctly', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [40000, 60000],
        );

        expect(estimate.label, contains('PKR'));
        expect(estimate.label, contains('–'));
      });

      test('handles realistic iPhone prices', () {
        final prices = [
          85000, 87000, 90000, 88000, 92000,
          86000, 89000, 91000, 88000, 85000,
          15000, // outlier
          200000, // outlier
        ];

        final estimate = PriceEstimatorService.calculatePriceEstimate(prices);

        expect(estimate.validListingsCount, lessThan(prices.length));
        expect(estimate.minPrice, greaterThan(80000));
        expect(estimate.maxPrice, lessThan(100000));
        expect(estimate.avgPrice, inInclusiveRange(85000, 92000));
      });

      test('handles tight price range (no outliers)', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [49000, 50000, 50000, 50000, 51000],
        );

        expect(estimate.removedOutliers, isEmpty);
        expect(estimate.validListingsCount, equals(5));
      });
    });

    group('getPriceLabel', () {
      test('returns good price label when within range', () {
        final label = PriceEstimatorService.getPriceLabel(50000, 50000);
        expect(label, contains('✅'));
        expect(label, contains('Good'));
      });

      test('returns high price label when above range', () {
        final label = PriceEstimatorService.getPriceLabel(70000, 50000);
        expect(label, contains('⚠️'));
        expect(label, contains('High'));
      });

      test('returns below market label when significantly below', () {
        final label = PriceEstimatorService.getPriceLabel(35000, 50000);
        expect(label, contains('🔥'));
        expect(label, contains('Below'));
      });

      test('returns empty string for zero average', () {
        final label = PriceEstimatorService.getPriceLabel(50000, 0);
        expect(label, isEmpty);
      });
    });

    group('formatPrice', () {
      test('formats price with commas', () {
        expect(
          PriceEstimatorService.formatPrice(1000000),
          equals('PKR 1,000,000'),
        );
      });

      test('formats smaller price without commas', () {
        expect(
          PriceEstimatorService.formatPrice(50000),
          equals('PKR 50,000'),
        );
      });

      test('formats very small price', () {
        expect(
          PriceEstimatorService.formatPrice(100),
          equals('PKR 100'),
        );
      });
    });

    group('getPriceInsight', () {
      test('returns price insight from estimate object', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [45000, 50000, 55000, 48000, 52000],
        );

        final insight = estimate.getPriceInsight(50000);
        expect(insight, contains('✅'));
      });

      test('returns below market insight', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [45000, 50000, 55000],
        );

        final insight = estimate.getPriceInsight(30000);
        expect(insight, contains('🔥'));
      });

      test('returns high price insight', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [45000, 50000, 55000],
        );

        final insight = estimate.getPriceInsight(70000);
        expect(insight, contains('⚠️'));
      });
    });

    group('Edge cases', () {
      test('handles all identical prices', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [50000, 50000, 50000, 50000],
        );

        expect(estimate.minPrice, equals(50000));
        expect(estimate.maxPrice, equals(50000));
        expect(estimate.avgPrice, equals(50000));
        expect(estimate.removedOutliers, isEmpty);
      });

      test('handles two prices far apart', () {
        final estimate = PriceEstimatorService.calculatePriceEstimate(
          [10000, 100000],
        );

        // One should be outlier
        expect(estimate.validListingsCount, lessThanOrEqualTo(2));
      });

      test('handles large dataset', () {
        final prices = List.generate(1000, (i) => 50000 + (i * 10));

        final estimate = PriceEstimatorService.calculatePriceEstimate(prices);

        expect(estimate.validListingsCount, greaterThan(0));
        expect(estimate.avgPrice, greaterThan(0));
      });
    });
  });
}
