import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_pak/services/price_alert_service.dart';
import 'package:mobile_pak/data/models/price_alert_model.dart';

void main() {
  group('PriceAlertService', () {
    group('isPriceDrop', () {
      test('returns true when current price is exactly at threshold', () {
        final result = PriceAlertService.isPriceDrop(100000, 95000, 5);
        expect(result, isTrue);
      });

      test('returns true when current price is below threshold', () {
        final result = PriceAlertService.isPriceDrop(100000, 90000, 5);
        expect(result, isTrue);
      });

      test('returns false when current price is above threshold', () {
        final result = PriceAlertService.isPriceDrop(100000, 96000, 5);
        expect(result, isFalse);
      });

      test('returns true for 10% drop threshold', () {
        final result = PriceAlertService.isPriceDrop(100000, 89000, 10);
        expect(result, isTrue);
      });

      test('returns false when no drop occurs', () {
        final result = PriceAlertService.isPriceDrop(100000, 100000, 5);
        expect(result, isFalse);
      });

      test('handles zero threshold (any decrease)', () {
        final result = PriceAlertService.isPriceDrop(100000, 99999, 0);
        expect(result, isTrue);
      });

      test('handles large price drops', () {
        final result = PriceAlertService.isPriceDrop(100000, 20000, 80);
        expect(result, isTrue);
      });
    });

    group('calculateDropPercent', () {
      test('calculates 5% drop correctly', () {
        final percent = PriceAlertService.calculateDropPercent(100000, 95000);
        expect(percent, equals(5));
      });

      test('calculates 10% drop correctly', () {
        final percent = PriceAlertService.calculateDropPercent(100000, 90000);
        expect(percent, equals(10));
      });

      test('calculates 50% drop correctly', () {
        final percent = PriceAlertService.calculateDropPercent(100000, 50000);
        expect(percent, equals(50));
      });

      test('returns 0 when prices are equal', () {
        final percent = PriceAlertService.calculateDropPercent(100000, 100000);
        expect(percent, equals(0));
      });

      test('returns 0 for zero watched price', () {
        final percent = PriceAlertService.calculateDropPercent(0, 50000);
        expect(percent, equals(0));
      });

      test('handles small price drops', () {
        final percent = PriceAlertService.calculateDropPercent(50000, 49000);
        expect(percent, equals(2));
      });

      test('rounds down percentage correctly', () {
        final percent = PriceAlertService.calculateDropPercent(100000, 97499);
        expect(percent, equals(2));
      });
    });

    group('PriceAlertModel serialization', () {
      test('converts to JSON and back correctly', () {
        final original = PriceAlertModel(
          id: 'alert_123',
          userId: 'user_456',
          productId: 'product_789',
          productTitle: 'iPhone 13 Pro',
          watchedPrice: 90000,
          targetDropPercent: 5,
          isActive: true,
          createdAt: DateTime(2026, 4, 23),
        );

        final json = original.toJson();
        final restored = PriceAlertModel.fromJson(json);

        expect(restored.id, equals(original.id));
        expect(restored.userId, equals(original.userId));
        expect(restored.productId, equals(original.productId));
        expect(restored.productTitle, equals(original.productTitle));
        expect(restored.watchedPrice, equals(original.watchedPrice));
        expect(restored.targetDropPercent, equals(original.targetDropPercent));
        expect(restored.isActive, equals(original.isActive));
      });

      test('handles DateTime parsing from string', () {
        final json = {
          'id': 'alert_123',
          'userId': 'user_456',
          'productId': 'product_789',
          'productTitle': 'iPhone 13 Pro',
          'watchedPrice': 90000,
          'targetDropPercent': 5,
          'isActive': true,
          'createdAt': '2026-04-23T12:00:00.000Z',
        };

        final alert = PriceAlertModel.fromJson(json);
        expect(alert.createdAt.year, equals(2026));
        expect(alert.createdAt.month, equals(4));
        expect(alert.createdAt.day, equals(23));
      });

      test('defaults targetDropPercent to 5 when missing', () {
        final json = {
          'id': 'alert_123',
          'userId': 'user_456',
          'productId': 'product_789',
          'productTitle': 'iPhone 13 Pro',
          'watchedPrice': 90000,
          'isActive': true,
          'createdAt': '2026-04-23T12:00:00.000Z',
        };

        final alert = PriceAlertModel.fromJson(json);
        expect(alert.targetDropPercent, equals(5));
      });

      test('defaults isActive to true when missing', () {
        final json = {
          'id': 'alert_123',
          'userId': 'user_456',
          'productId': 'product_789',
          'productTitle': 'iPhone 13 Pro',
          'watchedPrice': 90000,
          'targetDropPercent': 5,
          'createdAt': '2026-04-23T12:00:00.000Z',
        };

        final alert = PriceAlertModel.fromJson(json);
        expect(alert.isActive, isTrue);
      });
    });

    group('PriceAlertModel utilities', () {
      test('getTargetPrice calculates 5% drop correctly', () {
        final alert = PriceAlertModel(
          id: 'alert_123',
          userId: 'user_456',
          productId: 'product_789',
          productTitle: 'iPhone 13 Pro',
          watchedPrice: 100000,
          targetDropPercent: 5,
          isActive: true,
          createdAt: DateTime.now(),
        );

        expect(alert.getTargetPrice(), equals(95000));
      });

      test('getTargetPrice calculates 10% drop correctly', () {
        final alert = PriceAlertModel(
          id: 'alert_123',
          userId: 'user_456',
          productId: 'product_789',
          productTitle: 'iPhone 13 Pro',
          watchedPrice: 100000,
          targetDropPercent: 10,
          isActive: true,
          createdAt: DateTime.now(),
        );

        expect(alert.getTargetPrice(), equals(90000));
      });

      test('copyWith creates new instance with updated fields', () {
        final original = PriceAlertModel(
          id: 'alert_123',
          userId: 'user_456',
          productId: 'product_789',
          productTitle: 'iPhone 13 Pro',
          watchedPrice: 90000,
          targetDropPercent: 5,
          isActive: true,
          createdAt: DateTime(2026, 4, 23),
        );

        final updated = original.copyWith(isActive: false);

        expect(updated.id, equals(original.id));
        expect(updated.userId, equals(original.userId));
        expect(updated.isActive, isFalse);
        expect(original.isActive, isTrue);
      });

      test('copyWith preserves original fields when not specified', () {
        final original = PriceAlertModel(
          id: 'alert_123',
          userId: 'user_456',
          productId: 'product_789',
          productTitle: 'iPhone 13 Pro',
          watchedPrice: 90000,
          targetDropPercent: 5,
          isActive: true,
          createdAt: DateTime(2026, 4, 23),
        );

        final updated = original.copyWith(watchedPrice: 85000);

        expect(updated.watchedPrice, equals(85000));
        expect(updated.targetDropPercent, equals(5));
        expect(updated.userId, equals(original.userId));
      });
    });

    group('Edge cases', () {
      test('isPriceDrop handles maximum drop threshold', () {
        final result = PriceAlertService.isPriceDrop(100000, 1000, 99);
        expect(result, isTrue);
      });

      test('isPriceDrop handles 1% threshold', () {
        final result = PriceAlertService.isPriceDrop(100000, 99000, 1);
        expect(result, isTrue);
      });

      test('calculateDropPercent with very small prices', () {
        final percent = PriceAlertService.calculateDropPercent(1000, 500);
        expect(percent, equals(50));
      });

      test('calculateDropPercent with large prices', () {
        final percent = PriceAlertService.calculateDropPercent(1000000, 950000);
        expect(percent, equals(5));
      });

      test('isPriceDrop with realistic iPhone prices', () {
        // iPhone 13 Pro watched at 90,000, now 84,000 (6.7% drop)
        final result = PriceAlertService.isPriceDrop(90000, 84000, 5);
        expect(result, isTrue);
      });

      test('isPriceDrop with minimal price change', () {
        final result = PriceAlertService.isPriceDrop(100000, 99999, 5);
        expect(result, isFalse);
      });
    });
  });
}
