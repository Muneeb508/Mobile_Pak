class MarketRange {
  final int minPrice;
  final int maxPrice;
  final int averagePrice;
  final int medianPrice;
  final List<int> outliers;
  final int validListingsCount;

  MarketRange({
    required this.minPrice,
    required this.maxPrice,
    required this.averagePrice,
    required this.medianPrice,
    required this.outliers,
    required this.validListingsCount,
  });

  String get formattedRange => 'Rs $minPrice – Rs $maxPrice';

  int get priceSpread => maxPrice - minPrice;

  double get spreadPercentage => (priceSpread / averagePrice) * 100;
}
