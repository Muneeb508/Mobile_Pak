import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum TagCategory {
  condition,     // Excellent, Good, Fair
  priceRange,    // Budget, Mid-Range, Premium
  feature,       // PTA Approved, Hot Deal, Exchange
  location,      // City-based tags
  seller,        // Verified, Trusted Seller
  time,          // Just Listed, Popular
}

enum TagType {
  // Condition Tags
  excellent,
  good,
  fair,

  // Price Range Tags
  budget,
  midRange,
  premium,

  // Feature Tags
  ptaApproved,
  hotDeal,
  exchangeAvailable,
  verified,
  trustedSeller,

  // Time Tags
  justListed,
  popular,
  trending,

  // Custom
  custom,
}

class SmartTag {
  final TagType type;
  final String label;
  final String? description;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final TagCategory category;
  final int? priority; // Higher = more important

  const SmartTag({
    required this.type,
    required this.label,
    this.description,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    required this.category,
    this.priority = 0,
  });

  // Factory constructors for common tags
  factory SmartTag.excellent() => SmartTag(
    type: TagType.excellent,
    label: 'Excellent',
    description: 'Like new condition',
    backgroundColor: const Color(0xFFD1FAE5),
    textColor: const Color(0xFF065F46),
    icon: Icons.verified,
    category: TagCategory.condition,
    priority: 5,
  );

  factory SmartTag.good() => SmartTag(
    type: TagType.good,
    label: 'Good',
    description: 'Well-maintained',
    backgroundColor: const Color(0xFFE0E7FF),
    textColor: const Color(0xFF3730A3),
    icon: Icons.check_circle,
    category: TagCategory.condition,
    priority: 3,
  );

  factory SmartTag.fair() => SmartTag(
    type: TagType.fair,
    label: 'Fair',
    description: 'Needs care',
    backgroundColor: const Color(0xFFFEF3C7),
    textColor: const Color(0xFF92400E),
    icon: Icons.info,
    category: TagCategory.condition,
    priority: 1,
  );

  factory SmartTag.budget() => SmartTag(
    type: TagType.budget,
    label: 'Budget',
    description: 'Great value',
    backgroundColor: const Color(0xFFDCFCE7),
    textColor: const Color(0xFF065F46),
    icon: Icons.trending_down,
    category: TagCategory.priceRange,
    priority: 4,
  );

  factory SmartTag.midRange() => SmartTag(
    type: TagType.midRange,
    label: 'Mid-Range',
    description: 'Best value',
    backgroundColor: const Color(0xFFBFDBFE),
    textColor: const Color(0xFF1E40AF),
    icon: Icons.balance,
    category: TagCategory.priceRange,
    priority: 3,
  );

  factory SmartTag.premium() => SmartTag(
    type: TagType.premium,
    label: 'Premium',
    description: 'Top-tier',
    backgroundColor: const Color(0xFFFCE7F3),
    textColor: const Color(0xFF831843),
    icon: Icons.diamond,
    category: TagCategory.priceRange,
    priority: 2,
  );

  factory SmartTag.ptaApproved() => SmartTag(
    type: TagType.ptaApproved,
    label: 'PTA Approved',
    description: 'Certified authentic',
    backgroundColor: const Color(0xFFDEBEFC),
    textColor: const Color(0xFF581C87),
    icon: Icons.verified_user,
    category: TagCategory.feature,
    priority: 5,
  );

  factory SmartTag.hotDeal() => SmartTag(
    type: TagType.hotDeal,
    label: 'Hot Deal',
    description: 'Limited time',
    backgroundColor: const Color(0xFFFECACA),
    textColor: const Color(0xFF7F1D1D),
    icon: Icons.local_fire_department,
    category: TagCategory.feature,
    priority: 6,
  );

  factory SmartTag.exchangeAvailable() => SmartTag(
    type: TagType.exchangeAvailable,
    label: 'Exchange OK',
    description: 'Open to exchange',
    backgroundColor: const Color(0xFFCCFBF1),
    textColor: const Color(0xFF134E4A),
    icon: Icons.swap_horiz,
    category: TagCategory.feature,
    priority: 4,
  );

  factory SmartTag.verified() => SmartTag(
    type: TagType.verified,
    label: 'Verified',
    description: 'Authenticated',
    backgroundColor: const Color(0xFFDEBEFC),
    textColor: const Color(0xFF581C87),
    icon: Icons.verified,
    category: TagCategory.seller,
    priority: 4,
  );

  factory SmartTag.trustedSeller() => SmartTag(
    type: TagType.trustedSeller,
    label: 'Trusted Seller',
    description: 'High-rated seller',
    backgroundColor: const Color(0xFFBFE7F3),
    textColor: const Color(0xFF0E7490),
    icon: Icons.how_to_reg,
    category: TagCategory.seller,
    priority: 5,
  );

  factory SmartTag.justListed() => SmartTag(
    type: TagType.justListed,
    label: 'Just Listed',
    description: 'New arrival',
    backgroundColor: const Color(0xFFE7E5FF),
    textColor: const Color(0xFF4F46E5),
    icon: Icons.star_border,
    category: TagCategory.time,
    priority: 3,
  );

  factory SmartTag.popular() => SmartTag(
    type: TagType.popular,
    label: 'Popular',
    description: 'Many views',
    backgroundColor: const Color(0xFFFEE2E2),
    textColor: const Color(0xFF7F1D1D),
    icon: Icons.trending_up,
    category: TagCategory.time,
    priority: 3,
  );

  factory SmartTag.trending() => SmartTag(
    type: TagType.trending,
    label: 'Trending',
    description: 'Hot right now',
    backgroundColor: const Color(0xFFFFEDD5),
    textColor: const Color(0xFF7C2D12),
    icon: Icons.whatshot,
    category: TagCategory.time,
    priority: 4,
  );

  factory SmartTag.custom({
    required String label,
    required Color backgroundColor,
    required Color textColor,
    String? description,
    IconData? icon,
  }) => SmartTag(
    type: TagType.custom,
    label: label,
    description: description,
    backgroundColor: backgroundColor,
    textColor: textColor,
    icon: icon,
    category: TagCategory.feature,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SmartTag &&
          runtimeType == other.runtimeType &&
          type == other.type;

  @override
  int get hashCode => type.hashCode;
}
