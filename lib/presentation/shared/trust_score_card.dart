import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../../services/trust_score_service.dart';

class TrustScoreCard extends StatelessWidget {
  final Product product;

  const TrustScoreCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = TrustScoreService.computeScore(product);
    final bandLabel = TrustScoreService.getBandLabel(score);
    final bandColor = _getBandColor(score);
    final factors = TrustScoreService.getFactors(product);

    return Container(
      padding: EdgeInsets.all(AppDimensions.padding),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with score badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trust Score',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.gapMedium,
                  vertical: AppDimensions.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: bandColor.withOpacity(0.15),
                  border: Border.all(color: bandColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${score.toStringAsFixed(1)} / 10',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: bandColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.gapMedium),

          // Total progress bar with label
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 10.0,
              minHeight: 8,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(bandColor),
            ),
          ),
          SizedBox(height: AppDimensions.gapSmall),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              bandLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: bandColor,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.padding),

          // Factor rows
          ...factors.map((factor) => _buildFactorRow(context, factor)),

          // Footer explanation
          SizedBox(height: AppDimensions.gapMedium),
          Text(
            'Trust scores are calculated automatically based on verified listing data and seller history.',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorRow(BuildContext context, TrustFactor factor) {
    final passColor = _getScoreColor(factor.score, factor.maxScore);

    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.gapMedium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            factor.icon,
            size: 18,
            color: factor.passed ? passColor : AppColors.secondary,
          ),
          SizedBox(width: AppDimensions.gapMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  factor.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.gapMedium),
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: factor.maxScore > 0 ? factor.score / factor.maxScore : 0,
                minHeight: 6,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(passColor),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.gapSmall),
          SizedBox(
            width: 45,
            child: Text(
              '${factor.score.toStringAsFixed(1)}/${factor.maxScore.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBandColor(double score) {
    if (score >= 8.0) return AppColors.success;
    if (score >= 6.0) return AppColors.accent;
    if (score >= 4.0) return AppColors.warning;
    return AppColors.error;
  }

  Color _getScoreColor(double score, double maxScore) {
    if (maxScore == 0) return AppColors.secondary;
    final percentage = score / maxScore;
    if (percentage >= 0.8) return AppColors.success;
    if (percentage >= 0.5) return AppColors.accent;
    if (percentage >= 0.2) return AppColors.warning;
    return AppColors.error;
  }
}
