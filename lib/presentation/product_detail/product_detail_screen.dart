import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/controllers/price_alert_controller.dart';
import '../../core/controllers/recently_viewed_controller.dart';
import '../../services/market_price_range_service.dart';
import '../shared/price_insight_widget.dart';
import '../shared/widgets/price_alert_button.dart';
import '../shared/widgets/market_price_range_card.dart';
import '../shared/trust_score_card.dart';
import '../chat/chat_screen.dart';
import '../exchange/widgets/exchange_matches_section.dart';
import '../../services/exchange_matching_service.dart';
import '../../data/mock/mock_exchange_products.dart';
import 'widgets/image_slider.dart';
import 'widgets/seller_info_card.dart';
import 'widgets/seller_location_map.dart';
import 'widgets/specs_section.dart';
import 'widgets/exchange_options_section.dart';
import 'widgets/safety_tips_banner.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _checkPriceAlerts();
    _trackRecentlyViewed();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkPriceAlerts() async {
    try {
      final authController = Get.find<AuthController>();
      final alertController = Get.find<PriceAlertController>();
      final userId = authController.currentUser.value?.id;

      if (userId != null) {
        await alertController.checkAlertsForProduct(userId, widget.product);
      }
    } catch (e) {
      print('Error checking price alerts: $e');
    }
  }

  void _trackRecentlyViewed() {
    try {
      final recentlyViewedController = Get.find<RecentlyViewedController>();
      recentlyViewedController.addViewedProduct(widget.product);
    } catch (e) {
      print('Error tracking recently viewed: $e');
    }
  }

  void _showExchangeOfferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusLarge),
        ),
      ),
      builder: (context) => ExchangeOfferBottomSheet(product: widget.product),
    );
  }

  Future<void> _callSeller() async {
    final phoneNumber = 'tel:+923001234567';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        actions: [
          PriceAlertButton(product: widget.product),
          IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(
              images: widget.product.images,
              pageController: _pageController,
              onPageChanged: (index) {
                setState(() => _currentImageIndex = index);
              },
              currentIndex: _currentImageIndex,
            ),
            SizedBox(height: AppDimensions.padding),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            SizedBox(height: AppDimensions.gapSmall),
                            Text(
                              widget.product.formattedPrice,
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.product.isHotDeal)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.gapMedium,
                            vertical: AppDimensions.paddingSmall,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            border: Border.all(color: AppColors.error),
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                          ),
                          child: Text(
                            'Hot Deal',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.padding),
                  PriceInsightWidget(
                    listingPrice: widget.product.priceValue,
                    historicalAveragePrice: 50000,
                    marketMinPrice: 40000,
                    marketMaxPrice: 60000,
                    showDetails: true,
                  ),
                  SizedBox(height: AppDimensions.padding),
                  MarketPriceRangeCard(
                    listingPrice: widget.product.priceValue,
                    marketRange: MarketPriceRangeService.getMarketPriceRange(widget.product),
                  ),
                  SizedBox(height: AppDimensions.padding),
                  SellerInfoCard(seller: widget.product.seller),
                  SizedBox(height: AppDimensions.padding),
                  TrustScoreCard(product: widget.product),
                  SizedBox(height: AppDimensions.padding),
                  SellerLocationMap(product: widget.product),
                  SizedBox(height: AppDimensions.padding),
                  SpecsSection(product: widget.product),
                  SizedBox(height: AppDimensions.padding),
                  if (widget.product.isExchangeAvailable) ...[
                    ExchangeOptionsSection(product: widget.product),
                    SizedBox(height: AppDimensions.padding),
                    ExchangeMatchesSection(userProduct: widget.product),
                    SizedBox(height: AppDimensions.padding),
                  ],
                  SafetyTipsBanner(),
                  SizedBox(height: AppDimensions.padding),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.chat_outlined),
                          label: Text('Chat'),
                          onPressed: () => Get.to(() => ChatScreen(
                            product: widget.product,
                            sellerName: widget.product.seller.name,
                          )),
                        ),
                      ),
                      SizedBox(width: AppDimensions.gapMedium),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.phone_outlined),
                          label: Text('Call'),
                          onPressed: _callSeller,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.gapMedium),
                  if (widget.product.isExchangeAvailable)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.swap_horiz),
                        label: Text('Offer Exchange'),
                        onPressed: _showExchangeOfferSheet,
                      ),
                    ),
                  SizedBox(height: AppDimensions.padding),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExchangeOfferBottomSheet extends StatefulWidget {
  final Product product;

  const ExchangeOfferBottomSheet({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ExchangeOfferBottomSheet> createState() => _ExchangeOfferBottomSheetState();
}

class _ExchangeOfferBottomSheetState extends State<ExchangeOfferBottomSheet> {
  Product? _selectedDevice;
  final _cashDifferenceController = TextEditingController();

  @override
  void dispose() {
    _cashDifferenceController.dispose();
    super.dispose();
  }

  List<Product> _getCompatibleDevices() {
    return ExchangeMatchingService.findMatches(
      userProduct: widget.product,
      pool: mockExchangeProducts,
    ).map((m) => m.candidate).toList();
  }

  @override
  Widget build(BuildContext context) {
    final compatibleDevices = _getCompatibleDevices();

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Send Exchange Offer',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.padding),
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingSmall),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                  ),
                  child: Icon(Icons.image, color: AppColors.secondary),
                ),
                SizedBox(width: AppDimensions.gapMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.product.formattedPrice,
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.padding),
          Text(
            'Your Device',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: AppDimensions.gapMedium),
          if (compatibleDevices.isEmpty)
            Container(
              padding: EdgeInsets.all(AppDimensions.padding),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: Column(
                children: [
                  Icon(Icons.phone_android, size: 48, color: AppColors.secondary),
                  SizedBox(height: AppDimensions.gapMedium),
                  Text(
                    'No matching devices',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: AppDimensions.gapSmall),
                  Text(
                    'None of your listings match the required exchange range',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: compatibleDevices.length,
              itemBuilder: (context, index) {
                final device = compatibleDevices[index];
                final isSelected = _selectedDevice?.id == device.id;

                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDevice = device);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: AppDimensions.gapMedium),
                    padding: EdgeInsets.all(AppDimensions.paddingSmall),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withValues(alpha: 0.08) : AppColors.card,
                      border: Border.all(
                        color: isSelected ? AppColors.accent : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                          ),
                          child: Icon(Icons.image, color: AppColors.secondary),
                        ),
                        SizedBox(width: AppDimensions.gapMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                device.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                device.formattedPrice,
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(Icons.check_circle, color: AppColors.accent),
                      ],
                    ),
                  ),
                );
              },
            ),
          SizedBox(height: AppDimensions.padding),
          Text(
            'Cash Adjustment (Optional)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: AppDimensions.gapMedium),
          TextField(
            controller: _cashDifferenceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter amount (you pay positive, receive negative)',
              prefix: Text('Rs '),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                borderSide: BorderSide(color: AppColors.border),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.padding),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedDevice != null
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Exchange offer sent!')),
                      );
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('Send Offer'),
            ),
          ),
        ],
      ),
    );
  }
}
