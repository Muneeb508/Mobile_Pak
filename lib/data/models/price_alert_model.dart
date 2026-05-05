class PriceAlertModel {
  final String id;
  final String userId;
  final String productId;
  final String productTitle;
  final int watchedPrice;
  final int targetDropPercent;
  final bool isActive;
  final DateTime createdAt;

  PriceAlertModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.productTitle,
    required this.watchedPrice,
    required this.targetDropPercent,
    required this.isActive,
    required this.createdAt,
  });

  factory PriceAlertModel.fromJson(Map<String, dynamic> json) {
    return PriceAlertModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      productId: json['productId'] as String,
      productTitle: json['productTitle'] as String,
      watchedPrice: json['watchedPrice'] as int,
      targetDropPercent: json['targetDropPercent'] as int? ?? 5,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] is DateTime
          ? json['createdAt'] as DateTime
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'productTitle': productTitle,
      'watchedPrice': watchedPrice,
      'targetDropPercent': targetDropPercent,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int getTargetPrice() => (watchedPrice * (1 - targetDropPercent / 100)).toInt();

  PriceAlertModel copyWith({
    String? id,
    String? userId,
    String? productId,
    String? productTitle,
    int? watchedPrice,
    int? targetDropPercent,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return PriceAlertModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      productTitle: productTitle ?? this.productTitle,
      watchedPrice: watchedPrice ?? this.watchedPrice,
      targetDropPercent: targetDropPercent ?? this.targetDropPercent,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
