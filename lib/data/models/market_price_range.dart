class MarketPriceRange {
  final int minPrice;
  final int maxPrice;
  final String category; // e.g., "iPhone 13 Pro 256GB, Excellent"
  final int listingsCount; // Number of listings used to calculate range
  final DateTime lastUpdated;

  MarketPriceRange({
    required this.minPrice,
    required this.maxPrice,
    required this.category,
    required this.listingsCount,
    required this.lastUpdated,
  });

  // Calculate if current price is a good deal (below average)
  bool get isGoodDeal => false; // Will be set by comparison logic

  // Get the average market price
  int get averagePrice => ((minPrice + maxPrice) / 2).toInt();

  // Calculate percentage above/below average for any price
  int getPricePercentageFromAverage(int price) {
    if (averagePrice == 0) return 0;
    return (((price - averagePrice) / averagePrice) * 100).toInt();
  }
}
