import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';
import '../product_detail/product_detail_screen.dart';
import '../shared/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  List<Product> _mockProducts() {
    final mockSeller = UserModel(
      id: '1',
      name: 'Ali Khan',
      avatar: '',
      joinedAt: DateTime.now().subtract(Duration(days: 90)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 12,
      successfulDeals: 8,
      rating: 4.8,
    );

    return [
      Product(
        id: '1',
        title: 'iPhone 14 Pro Max',
        description: 'Excellent condition, all accessories included',
        priceValue: 180000,
        images: ['https://via.placeholder.com/300x300?text=iPhone+14+Pro'],
        specs: ['256GB', 'Space Black', 'PTA Approved'],
        location: 'Karachi',
        distance: '2 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 2)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: true,
        isExchangeAvailable: false,
        condition: 'Like New',
        batteryHealth: '95%',
        storage: '256GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '2',
        title: 'Samsung Galaxy S24',
        description: 'Original with warranty',
        priceValue: 140000,
        images: ['https://via.placeholder.com/300x300?text=Galaxy+S24'],
        specs: ['128GB', 'Phantom Black'],
        location: 'Lahore',
        distance: '5 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 5)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Good',
        batteryHealth: '88%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '3',
        title: 'OnePlus 12',
        description: 'Used for 4 months only',
        priceValue: 85000,
        images: ['https://via.placeholder.com/300x300?text=OnePlus+12'],
        specs: ['256GB', 'Silky Black'],
        location: 'Islamabad',
        distance: '12 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(days: 1)),
        isVerified: true,
        isPtaApproved: false,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Excellent',
        batteryHealth: '91%',
        storage: '256GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '4',
        title: 'iPhone 13 Pro',
        description: 'Minor scratches on back',
        priceValue: 120000,
        images: ['https://via.placeholder.com/300x300?text=iPhone+13+Pro'],
        specs: ['128GB', 'Sierra Blue'],
        location: 'Karachi',
        distance: '3 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 8)),
        isVerified: false,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Good',
        batteryHealth: '82%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '5',
        title: 'Google Pixel 8 Pro',
        description: 'Sealed in box, never used',
        priceValue: 175000,
        images: ['https://via.placeholder.com/300x300?text=Pixel+8+Pro'],
        specs: ['256GB', 'Obsidian'],
        location: 'Lahore',
        distance: '8 km',
        seller: mockSeller,
        postedAt: DateTime.now(),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: true,
        isExchangeAvailable: false,
        condition: 'Like New',
        batteryHealth: '100%',
        storage: '256GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '6',
        title: 'Xiaomi 14 Ultra',
        description: 'Refurbished, fully functional',
        priceValue: 95000,
        images: ['https://via.placeholder.com/300x300?text=Xiaomi+14'],
        specs: ['512GB', 'Black'],
        location: 'Rawalpindi',
        distance: '15 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 12)),
        isVerified: true,
        isPtaApproved: false,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Good',
        batteryHealth: '85%',
        storage: '512GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
        isSuspicious: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.appName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Row(
                      children: [
                        Icon(Icons.notifications_outlined, color: AppColors.primary),
                        SizedBox(width: AppDimensions.padding),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppColors.secondary),
                          SizedBox(width: AppDimensions.gapMedium),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search phones...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: AppColors.secondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.padding),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['PTA Approved', 'Under 100K', 'Deals', 'Nearby', 'Verified']
                            .map((filter) => Padding(
                              padding: EdgeInsets.only(right: AppDimensions.gapMedium),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.padding,
                                  vertical: AppDimensions.paddingSmall,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXLarge),
                                ),
                                child: Text(filter, style: TextStyle(fontSize: 13)),
                              ),
                            ))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: AppDimensions.padding),
                    Text(
                      'Latest For Sale',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppDimensions.padding),
                    SizedBox(
                      height: 200,
                      child: Center(
                        child: Text('Featured section coming soon...'),
                      ),
                    ),
                    SizedBox(height: AppDimensions.padding),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: AppDimensions.gapMedium,
                        mainAxisSpacing: AppDimensions.gapMedium,
                      ),
                      itemCount: _mockProducts().length,
                      itemBuilder: (context, index) {
                        final product = _mockProducts()[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                          onWishlistToggle: () {},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
