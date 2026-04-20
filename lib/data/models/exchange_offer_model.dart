import 'product_model.dart';

class ExchangeOffer {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String productId;
  final Product offeredDevice;
  final double? cashDifference;
  final String status;
  final DateTime sentAt;
  final bool isCrossTier;

  ExchangeOffer({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.productId,
    required this.offeredDevice,
    this.cashDifference,
    this.status = 'pending',
    required this.sentAt,
    this.isCrossTier = false,
  });

  factory ExchangeOffer.fromJson(Map<String, dynamic> json) {
    return ExchangeOffer(
      id: json['id'] ?? '',
      fromUserId: json['fromUserId'] ?? '',
      toUserId: json['toUserId'] ?? '',
      productId: json['productId'] ?? '',
      offeredDevice: Product.fromJson(json['offeredDevice'] ?? {}),
      cashDifference: json['cashDifference']?.toDouble(),
      status: json['status'] ?? 'pending',
      sentAt: json['sentAt'] is DateTime
          ? json['sentAt']
          : DateTime.parse(json['sentAt'] ?? DateTime.now().toString()),
      isCrossTier: json['isCrossTier'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUserId': fromUserId,
        'toUserId': toUserId,
        'productId': productId,
        'offeredDevice': offeredDevice.toJson(),
        'cashDifference': cashDifference,
        'status': status,
        'sentAt': sentAt.toIso8601String(),
        'isCrossTier': isCrossTier,
      };
}
