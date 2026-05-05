class RecentlyViewedItem {
  final String productId;
  final String title;
  final int price;
  final String imageUrl;
  final String location;
  final DateTime viewedAt;

  RecentlyViewedItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.viewedAt,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'location': location,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory RecentlyViewedItem.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedItem(
      productId: json['productId'] as String,
      title: json['title'] as String,
      price: json['price'] as int,
      imageUrl: json['imageUrl'] as String,
      location: json['location'] as String,
      viewedAt: DateTime.parse(json['viewedAt'] as String),
    );
  }

  // Copy with for immutability
  RecentlyViewedItem copyWith({
    String? productId,
    String? title,
    int? price,
    String? imageUrl,
    String? location,
    DateTime? viewedAt,
  }) {
    return RecentlyViewedItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyViewedItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}
