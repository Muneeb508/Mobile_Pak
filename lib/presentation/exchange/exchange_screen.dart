import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/exchange_tier.dart';
import '../product_detail/product_detail_screen.dart';
import '../shared/product_card.dart';
import '../shared/filter_pill.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({Key? key}) : super(key: key);

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  String? _selectedTier;
  String _searchQuery = '';

  List<Product> _getExchangeListings() {
    final mockSeller = UserModel(
      id: '1',
      name: 'Ahmed Hassan',
      avatar: '',
      joinedAt: DateTime.now().subtract(Duration(days: 60)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 18,
      successfulDeals: 15,
      rating: 4.9,
    );

    return [
      Product(
        id: 'ex1',
        title: 'iPhone 15 Pro - Exchange Available',
        description: 'Looking for mid-range Android phones',
        priceValue: 200000,
        images: ['https://via.placeholder.com/300x300?text=iPhone+15+Pro'],
        specs: ['256GB', 'Titanium Blue', 'PTA Verified'],
        location: 'Karachi',
        distance: '1.5 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 3)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Like New',
        batteryHealth: '98%',
        storage: '256GB',
        listingType: 'exchange',
        acceptedExchangeTiers: [ExchangeTier.midRange, ExchangeTier.highEnd],
        exchangeDescription: 'Samsung S24, OnePlus 12, Pixel 8',
      ),
      Product(
        id: 'ex2',
        title: 'Samsung Galaxy S24 Ultra - Trade In',
        description: 'Open for any flagship exchange',
        priceValue: 190000,
        images: ['https://via.placeholder.com/300x300?text=Galaxy+S24+Ultra'],
        specs: ['512GB', 'Titanium Black'],
        location: 'Lahore',
        distance: '4 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 7)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: true,
        isExchangeAvailable: true,
        condition: 'Excellent',
        batteryHealth: '94%',
        storage: '512GB',
        listingType: 'exchange',
        acceptedExchangeTiers: [ExchangeTier.highEnd],
        exchangeDescription: 'iPhone 15/14, Google Pixel 8 Pro',
      ),
      Product(
        id: 'ex3',
        title: 'OnePlus 12 - Budget Exchange',
        description: 'Want to upgrade? Trade with us',
        priceValue: 85000,
        images: ['https://via.placeholder.com/300x300?text=OnePlus+12'],
        specs: ['256GB', 'Black'],
        location: 'Islamabad',
        distance: '10 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 12)),
        isVerified: true,
        isPtaApproved: false,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Good',
        batteryHealth: '88%',
        storage: '256GB',
        listingType: 'exchange',
        acceptedExchangeTiers: [ExchangeTier.lowEnd, ExchangeTier.midRange],
        exchangeDescription: 'Any phone under 150K',
      ),
      Product(
        id: 'ex4',
        title: 'Google Pixel 8 Pro - Premium Trade',
        description: 'Flagship exchange partner needed',
        priceValue: 175000,
        images: ['https://via.placeholder.com/300x300?text=Pixel+8+Pro'],
        specs: ['128GB', 'Obsidian'],
        location: 'Karachi',
        distance: '2.5 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(days: 1)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Like New',
        batteryHealth: '96%',
        storage: '128GB',
        listingType: 'exchange',
        acceptedExchangeTiers: [ExchangeTier.midRange, ExchangeTier.highEnd],
        exchangeDescription: 'iPhone 13 Pro or better',
      ),
      Product(
        id: 'ex5',
        title: 'Xiaomi 14 Ultra - Flexible Exchange',
        description: 'Open to any reasonable trade',
        priceValue: 95000,
        images: ['https://via.placeholder.com/300x300?text=Xiaomi+14'],
        specs: ['512GB', 'Titanium Gray'],
        location: 'Rawalpindi',
        distance: '8 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 18)),
        isVerified: false,
        isPtaApproved: false,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Good',
        batteryHealth: '85%',
        storage: '512GB',
        listingType: 'exchange',
        acceptedExchangeTiers: [ExchangeTier.lowEnd, ExchangeTier.midRange, ExchangeTier.highEnd],
        exchangeDescription: 'Any smartphone',
      ),
      Product(
        id: 'ex6',
        title: 'iPhone 13 - Entry Level Exchange',
        description: 'Budget-friendly trade option',
        priceValue: 45000,
        images: ['https://via.placeholder.com/300x300?text=iPhone+13'],
        specs: ['128GB', 'Midnight'],
        location: 'Lahore',
        distance: '6 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(Duration(hours: 20)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Fair',
        batteryHealth: '78%',
        storage: '128GB',
        listingType: 'exchange',
        acceptedExchangeTiers: [ExchangeTier.lowEnd],
        exchangeDescription: 'Any budget phone under 50K',
      ),
    ];
  }

  List<Product> _getFilteredListings() {
    var listings = _getExchangeListings();

    if (_selectedTier != null) {
      final tier = ExchangeTier.values.byName(_selectedTier!);
      listings = listings
          .where((p) => p.acceptedExchangeTiers.contains(tier))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      listings = listings
          .where((p) => p.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return listings;
  }

  @override
  Widget build(BuildContext context) {
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exchange Market',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            SizedBox(height: AppDimensions.gapSmall),
                            Text(
                              'Trade your phone with verified sellers',
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.swap_horiz, size: 32, color: AppColors.accent),
                      ],
                    ),
                    SizedBox(height: AppDimensions.padding),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: AppColors.secondary),
                          SizedBox(width: AppDimensions.gapMedium),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                              decoration: InputDecoration(
                                hintText: 'Search exchange listings...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: AppColors.secondary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppDimensions.padding),
                    Text(
                      'Filter by Exchange Range',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: AppDimensions.gapMedium),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FilterPill(
                            label: 'All Ranges',
                            isSelected: _selectedTier == null,
                            onTap: () {
                              setState(() => _selectedTier = null);
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'Low End (< 50K)',
                            isSelected: _selectedTier == 'lowEnd',
                            onTap: () {
                              setState(() => _selectedTier = 'lowEnd');
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'Mid Range (50K-150K)',
                            isSelected: _selectedTier == 'midRange',
                            onTap: () {
                              setState(() => _selectedTier = 'midRange');
                            },
                          ),
                          SizedBox(width: AppDimensions.gapMedium),
                          FilterPill(
                            label: 'High End (> 150K)',
                            isSelected: _selectedTier == 'highEnd',
                            onTap: () {
                              setState(() => _selectedTier = 'highEnd');
                            },
                          ),
                        ],
                      ),
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
                        Icon(Icons.swap_horiz, size: 64, color: AppColors.secondary),
                        SizedBox(height: AppDimensions.padding),
                        Text(
                          'No exchange listings found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: AppDimensions.gapSmall),
                        Text(
                          'Try clearing your filters',
                          style: TextStyle(color: AppColors.secondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: AppDimensions.gapMedium,
                      mainAxisSpacing: AppDimensions.gapMedium,
                    ),
                    itemCount: filteredListings.length,
                    itemBuilder: (context, index) {
                      final product = filteredListings[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Get.to(() => ProductDetailScreen(product: product));
                        },
                        onWishlistToggle: () {},
                      );
                    },
                  ),
                ),
              SizedBox(height: AppDimensions.padding),
            ],
          ),
        ),
      ),
    );
  }
}
