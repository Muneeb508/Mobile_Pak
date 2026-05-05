import '../data/models/product_model.dart';
import '../data/models/exchange_match.dart';
import 'trust_score_service.dart';

class ExchangeMatchingService {
  static List<ExchangeMatch> findMatches({
    required Product userProduct,
    required List<Product> pool,
  }) {
    final matches = <ExchangeMatch>[];

    for (final candidate in pool) {
      if (candidate.id == userProduct.id) continue;
      if (candidate.listingType != 'exchange') continue;

      final match = scoreCandidate(
        userProduct: userProduct,
        candidate: candidate,
      );

      if (match != null) {
        matches.add(match);
      }
    }

    matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    return matches;
  }

  static ExchangeMatch? scoreCandidate({
    required Product userProduct,
    required Product candidate,
  }) {
    // Hard gate: Tier compatibility (bidirectional)
    final isMutualTier = userProduct.acceptedExchangeTiers.contains(candidate.ownTier) &&
        candidate.acceptedExchangeTiers.contains(userProduct.ownTier);

    if (!isMutualTier) {
      return null;
    }

    // Scoring components
    int score = 40; // Tier compatibility baseline

    // Price proximity (25 pts max)
    score += _scorePriceProximity(userProduct.priceValue, candidate.priceValue);

    // Same city (15 pts max)
    final isSameCity = userProduct.location.toLowerCase() == candidate.location.toLowerCase();
    if (isSameCity) {
      score += 15;
    }

    // Seller trust (12 pts max)
    final trustScore = TrustScoreService.computeScore(candidate);
    final trustPoints = ((trustScore / 10.0) * 12).round();
    score += trustPoints;

    // Condition quality (8 pts max)
    score += _scoreCondition(candidate.condition);

    // Clamp to [40, 100]
    score = score.clamp(40, 100);

    // Cash top-up calculation
    final priceDiff = candidate.priceValue - userProduct.priceValue;
    final higherPrice = priceDiff.abs() > 0 ? (userProduct.priceValue > candidate.priceValue ? userProduct.priceValue : candidate.priceValue) : userProduct.priceValue;
    final gapRatio = higherPrice > 0 ? priceDiff.abs() / higherPrice : 0.0;
    final cashTopUp = gapRatio > 0.05 ? priceDiff : null;

    // Trusted seller check
    final isTrustedSeller = trustScore >= 7.0;

    // Build match reasons
    final matchReasons = _buildReasons(
      isSameCity: isSameCity,
      isTrustedSeller: isTrustedSeller,
      trustScore: trustScore,
    );

    return ExchangeMatch(
      candidate: candidate,
      matchScore: score,
      isMutualTier: true,
      isSameCity: isSameCity,
      isTrustedSeller: isTrustedSeller,
      cashTopUp: cashTopUp,
      matchReasons: matchReasons,
    );
  }

  static int _scorePriceProximity(int priceA, int priceB) {
    if (priceA == 0 && priceB == 0) return 0;

    final gap = (priceA - priceB).abs();
    final higherPrice = priceA > priceB ? priceA : priceB;

    if (higherPrice == 0) return 0;

    final gapRatio = gap / higherPrice;

    if (gapRatio <= 0.05) return 25;
    if (gapRatio <= 0.15) return 18;
    if (gapRatio <= 0.30) return 10;
    if (gapRatio <= 0.50) return 5;
    return 0;
  }

  static int _scoreCondition(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'like new':
        return 7;
      case 'excellent':
        return 6;
      case 'good':
        return 4;
      case 'fair':
        return 2;
      case 'poor':
        return 0;
      default:
        return 3;
    }
  }

  static List<String> _buildReasons({
    required bool isSameCity,
    required bool isTrustedSeller,
    required double trustScore,
  }) {
    final reasons = <String>['Mutual Tier'];

    if (isSameCity) {
      reasons.add('Same City');
    }

    if (isTrustedSeller) {
      reasons.add('Trusted Seller');
    }

    if (trustScore >= 8.0) {
      reasons.add('Highly Rated');
    }

    return reasons;
  }
}
