import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/product_model.dart';
import '../../data/models/exchange_tier.dart';
import '../../data/mock/mock_exchange_products.dart';
import '../product_detail/product_detail_screen.dart';
import '../shared/product_card.dart';
import '../shared/filter_pill.dart';
import '../shared/widgets/empty_state.dart';

class ExchangeScreen extends StatefulWidget {
  const ExchangeScreen({Key? key}) : super(key: key);

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  String? _selectedTier;
  String _searchQuery = '';

  List<Product> _getExchangeListings() {
    return List.from(mockExchangeProducts);
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
                EmptyState(
                  type: EmptyStateType.noExchangeOffers,
                  onAction: () {
                    setState(() {
                      _selectedTier = null;
                      _searchQuery = '';
                    });
                  },
                  actionLabel: 'Clear Filters',
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
