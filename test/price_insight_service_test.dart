import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pak/services/price_insight_service.dart';

void main() {
  group('PriceInsightService', () {
    group('analyzePriceInsight', () {
      test('returns "Good price ✅" when price is within range (-15% to +10%)', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 45000,
          historicalAveragePrice: 50000,
          marketMinPrice: 40000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('Good price ✅'));
        expect(insight.insight, contains('Fairly priced'));
      });

      test('returns "High price ⚠️" when price is more than +10% above average', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 58000,
          historicalAveragePrice: 50000,
          marketMinPrice: 40000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('High price ⚠️'));
        expect(insight.insight, contains('above average'));
      });

      test('returns "Below market 🔥" when price is -25% or more below average', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 35000,
          historicalAveragePrice: 50000,
          marketMinPrice: 30000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('Below market 🔥'));
        expect(insight.insight, contains('great deal'));
      });

      test('returns "Unknown 📊" when historical average is 0', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 50000,
          historicalAveragePrice: 0,
          marketMinPrice: 40000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('Unknown 📊'));
      });

      test('handles edge case: exactly 10% above average (still good price)', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 55000,
          historicalAveragePrice: 50000,
          marketMinPrice: 40000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('Good price ✅'));
      });

      test('handles edge case: 11% above average (high price)', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 55500,
          historicalAveragePrice: 50000,
          marketMinPrice: 40000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('High price ⚠️'));
      });

      test('handles edge case: exactly -25% below average (below market)', () {
        final insight = PriceInsightService.analyzePriceInsight(
          listingPrice: 37500,
          historicalAveragePrice: 50000,
          marketMinPrice: 30000,
          marketMaxPrice: 60000,
        );

        expect(insight.label, equals('Below market 🔥'));
      });
    });

    group('calculatePercentageDifference', () {
      test('calculates correct percentage for price above average', () {
        final diff = PriceInsightService.calculatePercentageDifference(55000, 50000);
        expect(diff, equals(10.0));
      });

      test('calculates correct percentage for price below average', () {
        final diff = PriceInsightService.calculatePercentageDifference(45000, 50000);
        expect(diff, equals(-10.0));
      });

      test('returns 0 when average price is 0', () {
        final diff = PriceInsightService.calculatePercentageDifference(50000, 0);
        expect(diff, equals(0));
      });

      test('returns 0 when price equals average', () {
        final diff = PriceInsightService.calculatePercentageDifference(50000, 50000);
        expect(diff, equals(0));
      });
    });

    group('isPriceWithinMarketRange', () {
      test('returns true when price is within range', () {
        final isInRange =
            PriceInsightService.isPriceWithinMarketRange(50000, 40000, 60000);
        expect(isInRange, isTrue);
      });

      test('returns true when price equals min price', () {
        final isInRange =
            PriceInsightService.isPriceWithinMarketRange(40000, 40000, 60000);
        expect(isInRange, isTrue);
      });

      test('returns true when price equals max price', () {
        final isInRange =
            PriceInsightService.isPriceWithinMarketRange(60000, 40000, 60000);
        expect(isInRange, isTrue);
      });

      test('returns false when price is below min', () {
        final isInRange =
            PriceInsightService.isPriceWithinMarketRange(30000, 40000, 60000);
        expect(isInRange, isFalse);
      });

      test('returns false when price is above max', () {
        final isInRange =
            PriceInsightService.isPriceWithinMarketRange(70000, 40000, 60000);
        expect(isInRange, isFalse);
      });
    });
  });
}
