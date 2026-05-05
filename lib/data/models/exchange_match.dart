import 'product_model.dart';

class ExchangeMatch {
  final Product candidate;
  final int matchScore;
  final bool isMutualTier;
  final bool isSameCity;
  final bool isTrustedSeller;
  final int? cashTopUp;
  final List<String> matchReasons;

  const ExchangeMatch({
    required this.candidate,
    required this.matchScore,
    required this.isMutualTier,
    required this.isSameCity,
    required this.isTrustedSeller,
    required this.cashTopUp,
    required this.matchReasons,
  });
}
