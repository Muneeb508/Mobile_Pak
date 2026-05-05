import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../../data/models/exchange_match.dart';
import '../../data/mock/mock_exchange_products.dart';
import '../../services/exchange_matching_service.dart';
import 'widgets/exchange_match_card.dart';

class ExchangeMatchesScreen extends StatefulWidget {
  final Product userProduct;

  const ExchangeMatchesScreen({
    Key? key,
    required this.userProduct,
  }) : super(key: key);

  @override
  State<ExchangeMatchesScreen> createState() => _ExchangeMatchesScreenState();
}

enum SortOption { bestMatch, priceLow, priceHigh, trustedFirst }

class _ExchangeMatchesScreenState extends State<ExchangeMatchesScreen> {
  late List<ExchangeMatch> _matches;
  SortOption _selectedSort = SortOption.bestMatch;

  @override
  void initState() {
    super.initState();
    _matches = ExchangeMatchingService.findMatches(
      userProduct: widget.userProduct,
      pool: mockExchangeProducts,
    );
    _applySort();
  }

  void _applySort() {
    switch (_selectedSort) {
      case SortOption.bestMatch:
        _matches.sort((a, b) => b.matchScore.compareTo(a.matchScore));
        break;
      case SortOption.priceLow:
        _matches.sort((a, b) => a.candidate.priceValue.compareTo(b.candidate.priceValue));
        break;
      case SortOption.priceHigh:
        _matches.sort((a, b) => b.candidate.priceValue.compareTo(a.candidate.priceValue));
        break;
      case SortOption.trustedFirst:
        _matches.sort((a, b) {
          if (a.isTrustedSeller != b.isTrustedSeller) {
            return b.isTrustedSeller ? 1 : -1;
          }
          return b.matchScore.compareTo(a.matchScore);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Exchange Matches'),
            Text(
              '${_matches.length} compatible listings',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Sort chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(AppDimensions.padding),
              child: Row(
                children: [
                  _SortChip(
                    label: 'Best Match',
                    isSelected: _selectedSort == SortOption.bestMatch,
                    onTap: () {
                      setState(() {
                        _selectedSort = SortOption.bestMatch;
                        _applySort();
                      });
                    },
                  ),
                  SizedBox(width: AppDimensions.gapSmall),
                  _SortChip(
                    label: 'Price ↓',
                    isSelected: _selectedSort == SortOption.priceLow,
                    onTap: () {
                      setState(() {
                        _selectedSort = SortOption.priceLow;
                        _applySort();
                      });
                    },
                  ),
                  SizedBox(width: AppDimensions.gapSmall),
                  _SortChip(
                    label: 'Price ↑',
                    isSelected: _selectedSort == SortOption.priceHigh,
                    onTap: () {
                      setState(() {
                        _selectedSort = SortOption.priceHigh;
                        _applySort();
                      });
                    },
                  ),
                  SizedBox(width: AppDimensions.gapSmall),
                  _SortChip(
                    label: 'Trusted',
                    isSelected: _selectedSort == SortOption.trustedFirst,
                    onTap: () {
                      setState(() {
                        _selectedSort = SortOption.trustedFirst;
                        _applySort();
                      });
                    },
                  ),
                ],
              ),
            ),
            // Match list
            if (_matches.isEmpty)
              Padding(
                padding: EdgeInsets.all(AppDimensions.padding),
                child: Column(
                  children: [
                    Icon(
                      Icons.swap_horiz,
                      size: 48,
                      color: AppColors.secondary,
                    ),
                    SizedBox(height: AppDimensions.gapMedium),
                    Text(
                      'No matching exchanges',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(AppDimensions.padding),
                itemCount: _matches.length,
                itemBuilder: (context, index) {
                  final match = _matches[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.padding),
                    child: ExchangeMatchCard(
                      match: match,
                      compact: false,
                      onQuickExchange: () {
                        _openQuickExchange(match.candidate);
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  void _openQuickExchange(Product candidate) {
    // This will be implemented in context where we have access to ExchangeOfferBottomSheet
    Get.back();
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.card,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
