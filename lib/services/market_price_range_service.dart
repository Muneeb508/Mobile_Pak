import '../data/models/market_price_range.dart';
import '../data/models/product_model.dart';

class MarketPriceRangeService {
  // Mock market price data by device model and condition
  // In production, this would be calculated from actual listing data or fetched from backend
  static final Map<String, Map<String, Map<String, List<int>>>> _priceDatabase = {
    'iPhone 13 Pro': {
      'Excellent': {
        '128GB': [90000, 110000],
        '256GB': [100000, 125000],
        '512GB': [120000, 145000],
      },
      'Good': {
        '128GB': [75000, 95000],
        '256GB': [85000, 110000],
        '512GB': [105000, 130000],
      },
      'Fair': {
        '128GB': [60000, 80000],
        '256GB': [70000, 95000],
        '512GB': [90000, 115000],
      },
    },
    'iPhone 14': {
      'Excellent': {
        '128GB': [110000, 135000],
        '256GB': [125000, 155000],
        '512GB': [150000, 180000],
      },
      'Good': {
        '128GB': [95000, 120000],
        '256GB': [110000, 140000],
        '512GB': [135000, 165000],
      },
      'Fair': {
        '128GB': [80000, 105000],
        '256GB': [95000, 125000],
        '512GB': [120000, 150000],
      },
    },
    'Samsung Galaxy S22': {
      'Excellent': {
        '128GB': [75000, 95000],
        '256GB': [85000, 110000],
      },
      'Good': {
        '128GB': [60000, 80000],
        '256GB': [70000, 95000],
      },
      'Fair': {
        '128GB': [45000, 65000],
        '256GB': [55000, 80000],
      },
    },
    'Samsung Galaxy S23': {
      'Excellent': {
        '128GB': [90000, 115000],
        '256GB': [105000, 135000],
      },
      'Good': {
        '128GB': [75000, 100000],
        '256GB': [90000, 120000],
      },
      'Fair': {
        '128GB': [60000, 85000],
        '256GB': [75000, 105000],
      },
    },
  };

  static MarketPriceRange getMarketPriceRange(Product product) {
    // Extract device model from title (e.g., "iPhone 13 Pro 256GB")
    final title = product.title;
    final storage = product.storage;
    final condition = _normalizeCondition(product.condition);

    // Try to find matching price range in database
    for (final modelKey in _priceDatabase.keys) {
      if (title.contains(modelKey)) {
        final modelData = _priceDatabase[modelKey];
        if (modelData != null && modelData.containsKey(condition)) {
          final conditionData = modelData[condition]!;
          if (conditionData.containsKey(storage)) {
            final prices = conditionData[storage]!;
            return MarketPriceRange(
              minPrice: prices[0],
              maxPrice: prices[1],
              category: '$modelKey • $storage • $condition',
              listingsCount: _getListingsCount(modelKey, condition, storage),
              lastUpdated: DateTime.now(),
            );
          }
        }
      }
    }

    // Default fallback range if device not found
    return MarketPriceRange(
      minPrice: (product.priceValue * 0.85).toInt(),
      maxPrice: (product.priceValue * 1.15).toInt(),
      category: '${product.title} • ${product.condition}',
      listingsCount: 45,
      lastUpdated: DateTime.now(),
    );
  }

  static String _normalizeCondition(String condition) {
    if (condition.toLowerCase().contains('excellent') ||
        condition.toLowerCase().contains('like new')) {
      return 'Excellent';
    } else if (condition.toLowerCase().contains('good')) {
      return 'Good';
    } else if (condition.toLowerCase().contains('fair') ||
        condition.toLowerCase().contains('average')) {
      return 'Fair';
    }
    return 'Good'; // Default
  }

  static int _getListingsCount(String model, String condition, String storage) {
    // Mock listing counts - in production, get from backend
    final baseCount = <String, int>{
      'iPhone 13 Pro': 234,
      'iPhone 14': 567,
      'Samsung Galaxy S22': 189,
      'Samsung Galaxy S23': 312,
    };
    return baseCount[model] ?? 45;
  }

  // Compare listing price with market range
  static String getPriceStatus(int listingPrice, int minPrice, int maxPrice) {
    if (listingPrice <= minPrice) {
      return 'great_deal'; // Below market range
    } else if (listingPrice <= ((minPrice + maxPrice) / 2).toInt()) {
      return 'good_price'; // Below average
    } else if (listingPrice <= maxPrice) {
      return 'fair_price'; // Above average but within range
    } else {
      return 'overpriced'; // Above market range
    }
  }
}
