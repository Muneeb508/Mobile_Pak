import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/user_model.dart';
import '../../shared/verified_badge.dart';

class SellerInfoCard extends StatelessWidget {
  final UserModel seller;

  const SellerInfoCard({
    Key? key,
    required this.seller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              SizedBox(width: AppDimensions.padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          seller.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: AppDimensions.gapSmall),
                        if (seller.isVerified) VerifiedBadge(size: 14),
                      ],
                    ),
                    SizedBox(height: AppDimensions.gapSmall),
                    Text(
                      seller.memberSince,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, size: AppDimensions.iconSizeSmall),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(height: AppDimensions.padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(label: 'Listings', value: '${seller.totalListings}'),
              _StatItem(label: 'Deals', value: '${seller.successfulDeals}'),
              _StatItem(label: 'Response', value: '< 1 hour'),
            ],
          ),
          SizedBox(height: AppDimensions.padding),
          Row(
            children: [
              Expanded(
                child: RatingBar.builder(
                  initialRating: seller.rating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 18,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppColors.accent,
                  ),
                  onRatingUpdate: (_) {},
                  ignoreGestures: true,
                ),
              ),
              SizedBox(width: AppDimensions.gapMedium),
              Text(
                '${seller.rating.toStringAsFixed(1)}/5',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.padding),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text('View Profile'),
                ),
              ),
              SizedBox(width: AppDimensions.gapMedium),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text('Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppDimensions.gapSmall),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
