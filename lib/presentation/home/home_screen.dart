import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';
import '../product_detail/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _mockProducts() {
    final mockSeller1 = UserModel(
      id: '1',
      name: 'Ali Mobile Store',
      avatar: '',
      joinedAt: DateTime.now().subtract(const Duration(days: 90)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 12,
      successfulDeals: 8,
      rating: 4.8,
    );
    final mockSeller2 = UserModel(
      id: '2',
      name: 'Usman Mobile',
      avatar: '',
      joinedAt: DateTime.now().subtract(const Duration(days: 120)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 45,
      successfulDeals: 30,
      rating: 4.9,
    );
    final mockSeller3 = UserModel(
      id: '3',
      name: 'Tech Hub',
      avatar: '',
      joinedAt: DateTime.now().subtract(const Duration(days: 60)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 15,
      successfulDeals: 5,
      rating: 4.7,
    );
    final mockSeller4 = UserModel(
      id: '4',
      name: 'Hassan Traders',
      avatar: '',
      joinedAt: DateTime.now().subtract(const Duration(days: 300)),
      isPhoneVerified: true,
      isCnicVerified: true,
      isTrustedSeller: true,
      totalListings: 80,
      successfulDeals: 65,
      rating: 4.9,
    );

    return [
      Product(
        id: '1',
        title: 'iPhone 13 Pro',
        description: 'Excellent condition. Only minor scratches on back.',
        priceValue: 155000,
        images: ['https://dummyimage.com/300x400/222222/ffffff.png&text=iPhone+13+Pro'],
        specs: ['128GB', 'Space Gray', 'PTA Approved'],
        location: 'Lahore',
        distance: '2 km',
        seller: mockSeller1,
        postedAt: DateTime.now().subtract(const Duration(hours: 2)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Excellent',
        batteryHealth: '86%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '2',
        title: 'Samsung Galaxy S21 Ultra',
        description: 'Good condition. Slight back panel scratches.',
        priceValue: 95000,
        images: ['https://dummyimage.com/300x400/1a1a2e/ffffff.png&text=S21+Ultra'],
        specs: ['256GB', 'Phantom Black', 'PTA Approved'],
        location: 'Karachi',
        distance: '5 km',
        seller: mockSeller2,
        postedAt: DateTime.now().subtract(const Duration(hours: 3)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Good',
        batteryHealth: '82%',
        storage: '256GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '3',
        title: 'OnePlus 10 Pro',
        description: 'Very good condition. Used with care.',
        priceValue: 82000,
        images: ['https://dummyimage.com/300x400/8B0000/ffffff.png&text=OnePlus+10+Pro'],
        specs: ['128GB', 'Volcanic Black', 'PTA Approved'],
        location: 'Islamabad',
        distance: '12 km',
        seller: mockSeller3,
        postedAt: DateTime.now().subtract(const Duration(hours: 5)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Very Good',
        batteryHealth: '88%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
      Product(
        id: '4',
        title: 'Google Pixel 6a',
        description: 'Good condition. Smooth performance.',
        priceValue: 52000,
        images: ['https://dummyimage.com/300x400/f0f0f0/333333.png&text=Pixel+6a'],
        specs: ['128GB', 'Chalk', 'PTA Approved'],
        location: 'Multan',
        distance: '3 km',
        seller: mockSeller4,
        postedAt: DateTime.now().subtract(const Duration(hours: 6)),
        isVerified: true,
        isPtaApproved: true,
        isHotDeal: false,
        isExchangeAvailable: false,
        condition: 'Good',
        batteryHealth: '85%',
        storage: '128GB',
        listingType: 'sell',
        acceptedExchangeTiers: const [],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final products = _mockProducts();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky top section: Header + Search
            Container(
              color: AppColors.background,
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryChips(),
                    const SizedBox(height: 16),
                    _buildTrustBanner(),
                    const SizedBox(height: 20),
                    _buildLatestListingsHeader(),
                    const SizedBox(height: 8),
                    _buildListingCards(products),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // App icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 10),
          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile Pak',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buy & sell used mobiles in ',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: 'Pakistan',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right icons
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(Icons.swap_horiz_rounded, color: AppColors.secondary, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(Icons.notifications_outlined, color: AppColors.secondary, size: 20),
          ),
        ],
      ),
    );
  }

  // ─── SEARCH BAR ───────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.inputBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search, color: AppColors.secondary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search used mobiles...',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune, color: AppColors.secondary, size: 15),
                  const SizedBox(width: 5),
                  Text(
                    'Filter',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── CATEGORY CHIPS ───────────────────────────────────────
  Widget _buildCategoryChips() {
    final categories = ['Under 25K', '25K – 50K', '50K – 100K', '100K+'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // "All Categories" active chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.grid_view_rounded, color: Colors.white, size: 14),
                SizedBox(width: 6),
                Text(
                  'All Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Other chips
          ...categories.map((label) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.inputBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // ─── TRUST BANNER ─────────────────────────────────────────
  Widget _buildTrustBanner() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _trustItem(Icons.verified_user_outlined, 'Verified Sellers'),
          const SizedBox(width: 20),
          _trustItem(Icons.workspace_premium_outlined, 'Quality Checked'),
          const SizedBox(width: 20),
          _trustItem(Icons.handshake_outlined, 'Safe Transactions'),
          const SizedBox(width: 20),
          _trustItem(Icons.flag_circle_outlined, 'All Pakistan'),
        ],
      ),
    );
  }

  Widget _trustItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  // ─── LATEST LISTINGS HEADER ───────────────────────────────
  Widget _buildLatestListingsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Latest Listings',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Row(
            children: [
              Text(
                'Sort by: ',
                style: TextStyle(fontSize: 12, color: AppColors.secondary),
              ),
              Text(
                'Newest',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.secondary),
            ],
          ),
        ],
      ),
    );
  }

  // ─── LISTING CARDS ────────────────────────────────────────
  Widget _buildListingCards(List<Product> products) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      itemCount: products.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Get.to(() => ProductDetailScreen(product: products[index])),
          child: _buildCard(products[index], index),
        );
      },
    );
  }

  Widget _buildCard(Product product, int index) {
    final photoCount = [7, 6, 5, 5][index % 4];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── LEFT: Product Image ───
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.images.first,
                      width: 110,
                      height: 155,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 110,
                        height: 155,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(Icons.phone_android, color: AppColors.secondary, size: 36),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 110,
                        height: 155,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(Icons.phone_android, color: AppColors.secondary, size: 36),
                        ),
                      ),
                    ),
                  ),
                  // Photo count badge
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 10),
                          const SizedBox(width: 3),
                          Text(
                            '$photoCount Photos',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // ─── RIGHT: Details ───
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seller row
                    Row(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.accent.withValues(alpha: 0.3),
                          child: Text(
                            _getInitials(product.seller.name),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Seller name
                        Flexible(
                          child: Text(
                            product.seller.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Verified badge
                        if (product.seller.isTrustedSeller) ...[
                          Icon(Icons.check_circle, size: 14, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(
                            'Verified Seller',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                        const Spacer(),
                        // Time
                        Text(
                          timeago.format(product.postedAt, locale: 'en_short'),
                          style: TextStyle(fontSize: 10, color: AppColors.secondary),
                        ),
                        const SizedBox(width: 6),
                        // Heart
                        Icon(Icons.favorite_border, size: 18, color: AppColors.secondary),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Product title
                    Text(
                      product.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Spec pills
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _specPill(product.storage, false),
                        _specPill('Battery: ${product.batteryHealth}', false),
                        if (product.isPtaApproved) _specPill('PTA Approved', true),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      product.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Condition & Location
                    Row(
                      children: [
                        Text(
                          'Condition: ',
                          style: TextStyle(fontSize: 11, color: AppColors.secondary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getConditionBgColor(product.condition),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            product.condition,
                            style: TextStyle(
                              fontSize: 11,
                              color: _getConditionTextColor(product.condition),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Text('•', style: TextStyle(color: AppColors.border, fontSize: 11)),
                        ),
                        Icon(Icons.location_on_outlined, size: 13, color: AppColors.secondary),
                        const SizedBox(width: 2),
                        Text(
                          product.location,
                          style: TextStyle(fontSize: 11, color: AppColors.secondary),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Price & View Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          product.formattedPrice,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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

  // ─── HELPERS ──────────────────────────────────────────────

  Widget _specPill(String text, bool isGreen) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isGreen ? AppColors.accentLight : AppColors.inputBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isGreen ? AppColors.accent : AppColors.secondary,
        ),
      ),
    );
  }

  Color _getConditionBgColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
      case 'like new':
        return AppColors.accentLight;
      case 'very good':
        return AppColors.info.withValues(alpha: 0.1);
      case 'good':
        return AppColors.info.withValues(alpha: 0.1);
      default:
        return AppColors.inputBg;
    }
  }

  Color _getConditionTextColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
      case 'like new':
        return AppColors.accent;
      case 'very good':
        return AppColors.info;
      case 'good':
        return AppColors.info;
      default:
        return AppColors.secondary;
    }
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    String initials = '';
    for (int i = 0; i < (names.length > 2 ? 2 : names.length); i++) {
      if (names[i].isNotEmpty) initials += names[i][0];
    }
    return initials.toUpperCase();
  }
}
