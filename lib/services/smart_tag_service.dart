import '../data/models/smart_tag.dart';
import '../data/models/product_model.dart';

class SmartTagService {
  /// Generate smart tags for a product based on its properties
  static List<SmartTag> generateTags(Product product) {
    final tags = <SmartTag>[];

    // 1. Condition tags (highest priority)
    tags.addAll(_getConditionTags(product));

    // 2. Price range tags
    tags.addAll(_getPriceRangeTags(product));

    // 3. Feature tags
    tags.addAll(_getFeatureTags(product));

    // 4. Seller tags
    tags.addAll(_getSellerTags(product));

    // 5. Time-based tags
    tags.addAll(_getTimeTags(product));

    // Sort by priority (highest first) and limit to max 5 tags
    tags.sort((a, b) => (b.priority ?? 0).compareTo(a.priority ?? 0));
    return tags.take(5).toList();
  }

  /// Get condition-based tags
  static List<SmartTag> _getConditionTags(Product product) {
    final tags = <SmartTag>[];

    if (product.condition.toLowerCase().contains('excellent') ||
        product.condition.toLowerCase().contains('like new')) {
      tags.add(SmartTag.excellent());
    } else if (product.condition.toLowerCase().contains('good')) {
      tags.add(SmartTag.good());
    } else if (product.condition.toLowerCase().contains('fair') ||
        product.condition.toLowerCase().contains('average')) {
      tags.add(SmartTag.fair());
    }

    return tags;
  }

  /// Get price range tags based on price tier
  static List<SmartTag> _getPriceRangeTags(Product product) {
    final tags = <SmartTag>[];

    if (product.priceValue < 50000) {
      tags.add(SmartTag.budget());
    } else if (product.priceValue < 200000) {
      tags.add(SmartTag.midRange());
    } else {
      tags.add(SmartTag.premium());
    }

    return tags;
  }

  /// Get feature-based tags
  static List<SmartTag> _getFeatureTags(Product product) {
    final tags = <SmartTag>[];

    if (product.isHotDeal) {
      tags.add(SmartTag.hotDeal());
    }

    if (product.isPtaApproved) {
      tags.add(SmartTag.ptaApproved());
    }

    if (product.isExchangeAvailable) {
      tags.add(SmartTag.exchangeAvailable());
    }

    if (product.isVerified) {
      tags.add(SmartTag.verified());
    }

    return tags;
  }

  /// Get seller-based tags
  static List<SmartTag> _getSellerTags(Product product) {
    final tags = <SmartTag>[];

    if (product.seller.isTrustedSeller) {
      tags.add(SmartTag.trustedSeller());
    } else if (product.seller.isVerified) {
      tags.add(SmartTag.verified());
    }

    return tags;
  }

  /// Get time-based tags
  static List<SmartTag> _getTimeTags(Product product) {
    final tags = <SmartTag>[];

    final now = DateTime.now();
    final hoursSince = now.difference(product.postedAt).inHours;

    if (hoursSince < 24) {
      tags.add(SmartTag.justListed());
    } else if (hoursSince < 72) {
      tags.add(SmartTag.popular());
    } else if (hoursSince < 168) {
      tags.add(SmartTag.trending());
    }

    return tags;
  }

  /// Get tags by category
  static List<SmartTag> getTagsByCategory(
    Product product,
    TagCategory category,
  ) {
    final allTags = generateTags(product);
    return allTags.where((tag) => tag.category == category).toList();
  }

  /// Check if product matches a tag
  static bool hasTag(Product product, TagType type) {
    final tags = generateTags(product);
    return tags.any((tag) => tag.type == type);
  }

  /// Get total number of tags
  static int getTagCount(Product product) {
    return generateTags(product).length;
  }

  /// Get tag frequency in a list of products
  static Map<TagType, int> getTagFrequency(List<Product> products) {
    final frequency = <TagType, int>{};

    for (final product in products) {
      final tags = generateTags(product);
      for (final tag in tags) {
        frequency[tag.type] = (frequency[tag.type] ?? 0) + 1;
      }
    }

    return frequency;
  }

  /// Get popular tags across products
  static List<SmartTag> getPopularTags(List<Product> products, {int limit = 10}) {
    final frequency = getTagFrequency(products);
    final tags = <SmartTag>[];

    // Create a map of tag types to tag objects
    final tagMap = <TagType, SmartTag>{
      TagType.excellent: SmartTag.excellent(),
      TagType.good: SmartTag.good(),
      TagType.fair: SmartTag.fair(),
      TagType.budget: SmartTag.budget(),
      TagType.midRange: SmartTag.midRange(),
      TagType.premium: SmartTag.premium(),
      TagType.ptaApproved: SmartTag.ptaApproved(),
      TagType.hotDeal: SmartTag.hotDeal(),
      TagType.exchangeAvailable: SmartTag.exchangeAvailable(),
      TagType.verified: SmartTag.verified(),
      TagType.trustedSeller: SmartTag.trustedSeller(),
      TagType.justListed: SmartTag.justListed(),
      TagType.popular: SmartTag.popular(),
      TagType.trending: SmartTag.trending(),
    };

    // Sort by frequency
    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final entry in sorted.take(limit)) {
      final tag = tagMap[entry.key];
      if (tag != null) {
        tags.add(tag);
      }
    }

    return tags;
  }

  /// Filter products by tag
  static List<Product> filterByTag(List<Product> products, TagType tagType) {
    return products.where((product) => hasTag(product, tagType)).toList();
  }

  /// Multi-filter products by tags (AND logic)
  static List<Product> filterByTags(List<Product> products, List<TagType> tags) {
    return products.where((product) {
      return tags.every((tagType) => hasTag(product, tagType));
    }).toList();
  }

  /// Group products by tag
  static Map<TagType, List<Product>> groupByTag(List<Product> products) {
    final groups = <TagType, List<Product>>{};

    for (final product in products) {
      final productTags = generateTags(product);
      for (final tag in productTags) {
        groups.putIfAbsent(tag.type, () => []).add(product);
      }
    }

    return groups;
  }
}
