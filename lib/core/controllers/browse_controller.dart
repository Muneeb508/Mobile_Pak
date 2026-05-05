import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';

class BrowseController extends GetxController {
  final Rx<String?> selectedFilter = Rx<String?>(null);
  final RxString searchQuery = ''.obs;
  final RxList<Product> allProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockProducts();
  }

  void _loadMockProducts() {
    final mockSeller = UserModel(
      id: '1',
      name: 'Ali Khan',
      avatar: '',
      joinedAt: DateTime.now().subtract(const Duration(days: 90)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 12,
      successfulDeals: 8,
      rating: 4.8,
    );

    allProducts.value = [
      Product(
        id: '1',
        title: 'iPhone 14 Pro Max',
        description: 'Excellent condition, all accessories included',
        priceValue: 180000,
        images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=iPhone+14+Pro'],
        specs: ['256GB', 'Space Black', 'PTA Approved'],
        location: 'Karachi',
        distance: '2 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(const Duration(hours: 2)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: true,
        isExchangeAvailable: false,
        condition: 'Like New',
        batteryHealth: '95%',
        storage: '256GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
        latitude: 24.8607,
        longitude: 67.0011,
      ),
      Product(
        id: '2',
        title: 'Samsung Galaxy S24',
        description: 'Original with warranty',
        priceValue: 140000,
        images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=Galaxy+S24'],
        specs: ['128GB', 'Phantom Black'],
        location: 'Lahore',
        distance: '5 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(const Duration(hours: 5)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Good',
        batteryHealth: '88%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
        latitude: 31.5204,
        longitude: 74.3587,
      ),
      Product(
        id: '3',
        title: 'OnePlus 12',
        description: 'Used for 4 months only',
        priceValue: 85000,
        images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=OnePlus+12'],
        specs: ['256GB', 'Silky Black'],
        location: 'Islamabad',
        distance: '12 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
        isVerified: true,
        isPtaApproved: false,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Excellent',
        batteryHealth: '91%',
        storage: '256GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
        latitude: 33.6844,
        longitude: 73.0479,
      ),
      Product(
        id: '4',
        title: 'iPhone 13 Pro',
        description: 'Minor scratches on back',
        priceValue: 120000,
        images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=iPhone+13+Pro'],
        specs: ['128GB', 'Sierra Blue'],
        location: 'Karachi',
        distance: '3 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(const Duration(hours: 8)),
        isVerified: false,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: true,
        condition: 'Good',
        batteryHealth: '82%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
        latitude: 24.8721,
        longitude: 67.0301,
      ),
      Product(
        id: '5',
        title: 'Google Pixel 8 Pro',
        description: 'Sealed in box, never used',
        priceValue: 175000,
        images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=Pixel+8+Pro'],
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
        latitude: 31.4504,
        longitude: 74.3794,
      ),
      Product(
        id: '6',
        title: 'Xiaomi 14 Ultra',
        description: 'Refurbished, fully functional',
        priceValue: 95000,
        images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=Xiaomi+14'],
        specs: ['512GB', 'Black'],
        location: 'Rawalpindi',
        distance: '15 km',
        seller: mockSeller,
        postedAt: DateTime.now().subtract(const Duration(hours: 12)),
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
        latitude: 33.5651,
        longitude: 73.0169,
      ),
    ];
  }

  List<Product> get filteredListings {
    var listings = List<Product>.from(allProducts);
    final filter = selectedFilter.value;
    final query = searchQuery.value.toLowerCase();

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
          .where((p) => p.title.toLowerCase().contains(query))
          .toList();
    }

    return listings;
  }

  void setFilter(String? filter) {
    selectedFilter.value = filter;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
