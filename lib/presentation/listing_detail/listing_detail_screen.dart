import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../chat/chat_screen.dart';
import 'widgets/price_estimator_sheet.dart';

class ListingDetailScreen extends StatefulWidget {
  final Product product;

  const ListingDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuSelection(value, context),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'estimate_price',
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 20),
                    SizedBox(width: 12),
                    Text('Estimate Market Price'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20),
                    SizedBox(width: 12),
                    Text('Share Listing'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag, size: 20),
                    SizedBox(width: 12),
                    Text('Report Listing'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder
            Container(
              width: double.infinity,
              height: 300,
              color: AppColors.border,
              child: Icon(
                Icons.image,
                size: 80,
                color: AppColors.secondary,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppDimensions.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    widget.product.formattedPrice,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Condition badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                    ),
                    child: Text(
                      widget.product.condition,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(color: AppColors.secondary),
                  ),
                  const SizedBox(height: 24),

                  // Specifications
                  Text(
                    'Specifications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.product.specs.map((spec) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(Icons.check, size: 18, color: AppColors.accent),
                          const SizedBox(width: 12),
                          Text(spec),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  // Seller Info
                  Text(
                    'Seller Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(AppDimensions.padding),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                          child: Icon(Icons.person, color: AppColors.accent),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.seller.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Active since ${widget.product.seller.memberSince}',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.chat_outlined),
                          label: const Text('Chat'),
                          onPressed: () {
                            Get.to(() => ChatScreen(
                                  product: widget.product,
                                  sellerName: widget.product.seller.name,
                                ));
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.phone_outlined),
                          label: const Text('Call'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('More from this seller'),
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

  void _handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'estimate_price':
        _showPriceEstimator(context);
        break;
      case 'share':
        _sharePrice(context);
        break;
      case 'report':
        _reportListing(context);
        break;
    }
  }

  void _showPriceEstimator(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => PriceEstimatorSheet(product: widget.product),
    );
  }

  void _sharePrice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _reportListing(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report functionality coming soon')),
    );
  }
}
