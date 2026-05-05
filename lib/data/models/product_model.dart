import 'exchange_tier.dart';
import 'user_model.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final int priceValue;
  final List<String> images;
  final List<String> specs;
  final String location;
  final String distance;
  final bool isVerified;
  final bool isPtaApproved;
  final bool isHotDeal;
  final bool isExchangeAvailable;
  final String condition;
  final String batteryHealth;
  final String storage;
  final String listingType;
  final List<ExchangeTier> acceptedExchangeTiers;
  final String? exchangeDescription;
  final UserModel seller;
  final DateTime postedAt;
  final bool isSuspicious;
  final double? latitude;
  final double? longitude;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.priceValue,
    required this.images,
    required this.specs,
    required this.location,
    required this.distance,
    required this.seller,
    required this.postedAt,
    this.isVerified = false,
    this.isPtaApproved = false,
    this.isHotDeal = false,
    this.isExchangeAvailable = false,
    this.condition = 'Good',
    this.batteryHealth = '80%',
    this.storage = '128GB',
    this.listingType = 'sell',
    this.acceptedExchangeTiers = const [],
    this.exchangeDescription,
    this.isSuspicious = false,
    this.latitude,
    this.longitude,
  });

  ExchangeTier get ownTier {
    if (priceValue < 50000) return ExchangeTier.lowEnd;
    if (priceValue < 150000) return ExchangeTier.midRange;
    return ExchangeTier.highEnd;
  }

  String get exchangeLabel {
    if (acceptedExchangeTiers.isEmpty) return '';
    final labels = acceptedExchangeTiers.map((t) => t.label.split(' ').first);
    return 'Exchange: ${labels.join('–')}';
  }

  String get formattedPrice => 'Rs ${priceValue.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      )}';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      priceValue: json['priceValue'] ?? 0,
      images: List<String>.from(json['images'] ?? []),
      specs: List<String>.from(json['specs'] ?? []),
      location: json['location'] ?? '',
      distance: json['distance'] ?? '',
      isVerified: json['isVerified'] ?? false,
      isPtaApproved: json['isPtaApproved'] ?? false,
      isHotDeal: json['isHotDeal'] ?? false,
      isExchangeAvailable: json['isExchangeAvailable'] ?? false,
      condition: json['condition'] ?? 'Good',
      batteryHealth: json['batteryHealth'] ?? '80%',
      storage: json['storage'] ?? '128GB',
      listingType: json['listingType'] ?? 'sell',
      acceptedExchangeTiers: (json['acceptedExchangeTiers'] as List?)
              ?.map((e) => ExchangeTier.values.byName(e))
              .toList() ??
          [],
      exchangeDescription: json['exchangeDescription'],
      seller: UserModel.fromJson(json['seller'] ?? {}),
      postedAt: json['postedAt'] is DateTime
          ? json['postedAt']
          : DateTime.parse(json['postedAt'] ?? DateTime.now().toString()),
      isSuspicious: json['isSuspicious'] ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'priceValue': priceValue,
        'images': images,
        'specs': specs,
        'location': location,
        'distance': distance,
        'isVerified': isVerified,
        'isPtaApproved': isPtaApproved,
        'isHotDeal': isHotDeal,
        'isExchangeAvailable': isExchangeAvailable,
        'condition': condition,
        'batteryHealth': batteryHealth,
        'storage': storage,
        'listingType': listingType,
        'acceptedExchangeTiers': acceptedExchangeTiers.map((e) => e.name).toList(),
        'exchangeDescription': exchangeDescription,
        'seller': seller.toJson(),
        'postedAt': postedAt.toIso8601String(),
        'isSuspicious': isSuspicious,
        'latitude': latitude,
        'longitude': longitude,
      };
}
