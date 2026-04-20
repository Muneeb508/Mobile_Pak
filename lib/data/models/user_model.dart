import 'package:timeago/timeago.dart' as timeago;

class UserModel {
  final String id;
  final String name;
  final String avatar;
  final DateTime joinedAt;
  final bool isPhoneVerified;
  final bool isCnicVerified;
  final bool isTrustedSeller;
  final int totalListings;
  final int successfulDeals;
  final double rating;

  UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.joinedAt,
    this.isPhoneVerified = false,
    this.isCnicVerified = false,
    this.isTrustedSeller = false,
    this.totalListings = 0,
    this.successfulDeals = 0,
    this.rating = 0.0,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    DateTime? joinedAt,
    bool? isPhoneVerified,
    bool? isCnicVerified,
    bool? isTrustedSeller,
    int? totalListings,
    int? successfulDeals,
    double? rating,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      joinedAt: joinedAt ?? this.joinedAt,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isCnicVerified: isCnicVerified ?? this.isCnicVerified,
      isTrustedSeller: isTrustedSeller ?? this.isTrustedSeller,
      totalListings: totalListings ?? this.totalListings,
      successfulDeals: successfulDeals ?? this.successfulDeals,
      rating: rating ?? this.rating,
    );
  }

  String get memberSince => timeago.format(joinedAt, locale: 'en_short');

  bool get isVerified => isPhoneVerified && isCnicVerified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      joinedAt: json['joinedAt'] is DateTime
          ? json['joinedAt']
          : DateTime.parse(json['joinedAt'] ?? DateTime.now().toString()),
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isCnicVerified: json['isCnicVerified'] ?? false,
      isTrustedSeller: json['isTrustedSeller'] ?? false,
      totalListings: json['totalListings'] ?? 0,
      successfulDeals: json['successfulDeals'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
        'joinedAt': joinedAt.toIso8601String(),
        'isPhoneVerified': isPhoneVerified,
        'isCnicVerified': isCnicVerified,
        'isTrustedSeller': isTrustedSeller,
        'totalListings': totalListings,
        'successfulDeals': successfulDeals,
        'rating': rating,
      };
}
