import 'package:flutter/material.dart';
import '../data/models/product_model.dart';

class TrustFactor {
  final String label;
  final String description;
  final double score;
  final double maxScore;
  final bool passed;
  final IconData icon;

  TrustFactor({
    required this.label,
    required this.description,
    required this.score,
    required this.maxScore,
    required this.passed,
    required this.icon,
  });
}

class TrustScoreService {
  static double computeScore(Product product) {
    double score = 0;
    final seller = product.seller;

    // Seller signals (max 5.0)
    if (seller.isTrustedSeller) score += 1.0;
    if (seller.isCnicVerified) score += 0.5;
    if (seller.isPhoneVerified) score += 0.5;
    score += (seller.rating / 5.0) * 1.5; // up to 1.5

    // Deal history (up to 0.5)
    final totalListings = seller.totalListings > 0 ? seller.totalListings : 1;
    score += (seller.successfulDeals / totalListings) * 0.5;

    // Account age (up to 1.0)
    final ageDays = DateTime.now().difference(seller.joinedAt).inDays;
    if (ageDays > 180) {
      score += 1.0;
    } else if (ageDays > 30) {
      score += 0.5;
    }

    // Listing signals (max 5.0)
    if (product.isVerified) score += 2.0;
    if (product.isPtaApproved) score += 0.5;
    if (product.latitude != null) score += 0.5;

    // Listing completeness (up to 1.0)
    if (product.images.length >= 3) {
      score += 0.5;
    } else if (product.images.isNotEmpty) {
      score += 0.25;
    }
    if (product.specs.length >= 3) score += 0.5;

    // Suspicious penalty
    if (product.isSuspicious) score -= 3.0;

    // Clamp to [0, 10]
    return score.clamp(0.0, 10.0);
  }

  static List<TrustFactor> getFactors(Product product) {
    final seller = product.seller;
    final factors = <TrustFactor>[];

    // Verified Listing (2.0 max)
    final verifiedScore = product.isVerified ? 2.0 : 0.0;
    factors.add(TrustFactor(
      label: 'Verified Listing',
      description: 'Listing has been reviewed and verified',
      score: verifiedScore,
      maxScore: 2.0,
      passed: product.isVerified,
      icon: Icons.verified_outlined,
    ));

    // PTA Approved (0.5 max)
    final ptaScore = product.isPtaApproved ? 0.5 : 0.0;
    factors.add(TrustFactor(
      label: 'PTA Approved',
      description: 'Device meets regulatory standards',
      score: ptaScore,
      maxScore: 0.5,
      passed: product.isPtaApproved,
      icon: Icons.check_circle_outlined,
    ));

    // Trusted Seller (1.0 max)
    final trustedScore = seller.isTrustedSeller ? 1.0 : 0.0;
    factors.add(TrustFactor(
      label: 'Trusted Seller',
      description: 'Seller has platform trust badge',
      score: trustedScore,
      maxScore: 1.0,
      passed: seller.isTrustedSeller,
      icon: Icons.verified_user_outlined,
    ));

    // Seller Rating (1.5 max)
    final ratingScore = (seller.rating / 5.0) * 1.5;
    factors.add(TrustFactor(
      label: 'Seller Rating',
      description: 'Based on ${seller.rating}/5 star rating',
      score: ratingScore,
      maxScore: 1.5,
      passed: seller.rating > 0,
      icon: Icons.star_outlined,
    ));

    // Identity Verified (1.0 max)
    final identityScore =
        (seller.isCnicVerified ? 0.5 : 0.0) + (seller.isPhoneVerified ? 0.5 : 0.0);
    factors.add(TrustFactor(
      label: 'Identity Verified',
      description: 'CNIC and phone verified',
      score: identityScore,
      maxScore: 1.0,
      passed: seller.isCnicVerified || seller.isPhoneVerified,
      icon: Icons.badge_outlined,
    ));

    // Account Age (1.0 max)
    final ageDays = DateTime.now().difference(seller.joinedAt).inDays;
    double ageScore = 0.0;
    if (ageDays > 180) {
      ageScore = 1.0;
    } else if (ageDays > 30) {
      ageScore = 0.5;
    }
    factors.add(TrustFactor(
      label: 'Account Age',
      description: 'Member for ${seller.memberSince}',
      score: ageScore,
      maxScore: 1.0,
      passed: ageDays > 0,
      icon: Icons.history_outlined,
    ));

    // Listing Completeness (1.0 max)
    double completenessScore = 0.0;
    if (product.images.length >= 3) {
      completenessScore += 0.5;
    } else if (product.images.isNotEmpty) {
      completenessScore += 0.25;
    }
    if (product.specs.length >= 3) completenessScore += 0.5;
    factors.add(TrustFactor(
      label: 'Listing Completeness',
      description:
          '${product.images.length} images, ${product.specs.length} specs',
      score: completenessScore,
      maxScore: 1.0,
      passed: completenessScore > 0,
      icon: Icons.list_outlined,
    ));

    // Location Shared (0.5 max)
    final locationScore = product.latitude != null ? 0.5 : 0.0;
    factors.add(TrustFactor(
      label: 'Location Shared',
      description: 'Seller location is available',
      score: locationScore,
      maxScore: 0.5,
      passed: product.latitude != null,
      icon: Icons.location_on_outlined,
    ));

    // Deal Completion (0.5 max)
    final totalListings = seller.totalListings > 0 ? seller.totalListings : 1;
    final dealScore = (seller.successfulDeals / totalListings) * 0.5;
    factors.add(TrustFactor(
      label: 'Deal Completion',
      description: '${seller.successfulDeals} of ${seller.totalListings} deals',
      score: dealScore,
      maxScore: 0.5,
      passed: seller.successfulDeals > 0,
      icon: Icons.handshake_outlined,
    ));

    return factors;
  }

  static String getBandLabel(double score) {
    if (score >= 8.0) return 'Excellent';
    if (score >= 6.0) return 'Good';
    if (score >= 4.0) return 'Fair';
    return 'Low';
  }
}
