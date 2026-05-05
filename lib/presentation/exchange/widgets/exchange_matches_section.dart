import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';
import '../../../data/mock/mock_exchange_products.dart';
import '../../../services/exchange_matching_service.dart';
import '../exchange_matches_screen.dart';
import 'exchange_match_card.dart';

class ExchangeMatchesSection extends StatelessWidget {
  final Product userProduct;

  const ExchangeMatchesSection({
    Key? key,
    required this.userProduct,
  }) : super(key: key);

  void _openExchangeOfferSheet(BuildContext context, Product candidate) {
    // This will be called by the match card's button
    // We'll implement the actual bottom sheet call in the card
  }

  @override
  Widget build(BuildContext context) {
    final matches = ExchangeMatchingService.findMatches(
      userProduct: userProduct,
      pool: mockExchangeProducts,
    );

    if (matches.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.padding,
          vertical: AppDimensions.paddingSmall,
        ),
        child: Column(
          children: [
            Icon(
              Icons.swap_horiz,
              size: 40,
              color: AppColors.secondary,
            ),
            SizedBox(height: AppDimensions.gapMedium),
            Text(
              'No compatible exchanges',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppDimensions.gapSmall),
            Text(
              'No matching exchange listings found yet',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.paddingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Best Exchange Matches',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: AppDimensions.gapSmall),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${matches.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Get.to(
                  () => ExchangeMatchesScreen(userProduct: userProduct),
                ),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
            itemCount: matches.length > 5 ? 5 : matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Padding(
                padding: EdgeInsets.only(right: AppDimensions.gapMedium),
                child: ExchangeMatchCard(
                  match: match,
                  compact: true,
                  onQuickExchange: () {
                    _openQuickExchange(context, match.candidate);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openQuickExchange(BuildContext context, Product candidate) {
    // This will trigger the exchange offer bottom sheet from product_detail_screen
    // For now, we'll pass the candidate product
    // The implementation will be in the context of product_detail_screen
    // where we have access to the ExchangeOfferBottomSheet
  }
}
