import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';
import '../product_detail/product_detail_screen.dart';
import '../shared/product_card.dart';
import '../shared/filter_pill.dart';
import '../../core/controllers/browse_controller.dart';
import '../../core/controllers/wishlist_controller.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({Key? key}) : super(key: key);

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final browseController = Get.find<BrowseController>();

  List<Product> _getForSaleListings() {
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

  List<Product> _getFilteredListings() {
    var listings = _getForSaleListings();
    final filter = browseController.selectedFilter.value;
    final query = browseController.searchQuery.value;

    if (filter != null) {
      switch (filter) {
        case 'verified':
          listings = listings.where((p) => p.isVerified).toList();
          break;
        case 'pta':
          listings = listings.where((p) => p.isPtaApproved).toList();
          break;
        case 'deals':
          listings = listings.where((p) => p.isHotDeal).toList();
          break;
        case 'nearby':
          listings = listings
              .where((p) => int.parse(p.distance.split(' ')[0]) < 10)
              .toList();
          break;
        case 'under100k':
          listings = listings.where((p) => p.priceValue < 100000).toList();
          break;
      }
    }

    if (query.isNotEmpty) {
      listings = listings
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return listings;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredListings = _getFilteredListings();

      return Scaffold(
        backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                    SizedBox(height: AppDimensions.padding),
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
                              onChanged: (value) {
                                browseController.setSearchQuery(value);
                              },
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
                      child: Obx(() => Row(
                        children: [
                          FilterPill(
                            label: 'All',
                            isSelected: browseController.selectedFilter.value == null,
                            onTap: () {
                              browseController.setFilter(null);
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'PTA Approved',
                            isSelected: browseController.selectedFilter.value == 'pta',
                            onTap: () {
                              browseController.setFilter('pta');
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'Under 100K',
                            isSelected: browseController.selectedFilter.value == 'under100k',
                            onTap: () {
                              browseController.setFilter('under100k');
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'Deals',
                            isSelected: browseController.selectedFilter.value == 'deals',
                            onTap: () {
                              browseController.setFilter('deals');
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'Nearby',
                            isSelected: browseController.selectedFilter.value == 'nearby',
                            onTap: () {
                              browseController.setFilter('nearby');
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'Verified',
                            isSelected: browseController.selectedFilter.value == 'verified',
                            onTap: () {
                              browseController.setFilter('verified');
                            },
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              if (filteredListings.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.padding),
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 64, color: AppColors.secondary),
                        SizedBox(height: AppDimensions.padding),
                        Text(
                          'No listings found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: AppDimensions.gapSmall),
                        Text(
                          'Try different search terms or filters',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                AnimationLimiter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredListings.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: AppDimensions.gapMedium,
                        mainAxisSpacing: AppDimensions.gapMedium,
                      ),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          columnCount: 2,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: ProductCard(
                                product: filteredListings[index],
                                onTap: () {
                                  Get.to(() => ProductDetailScreen(product: filteredListings[index]));
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              SizedBox(height: AppDimensions.padding),
            ],
          ),
        ),
      ),
    );
    });
  }
}
