import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../services/trust_score_service.dart';

class TrustScoreBadge extends StatelessWidget {
  final Product product;

  const TrustScoreBadge({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final score = TrustScoreService.computeScore(product);
    final bandLabel = TrustScoreService.getBandLabel(score);
    final bandColor = _getBandColor(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: bandColor.withOpacity(0.15),
        border: Border.all(color: bandColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            color: bandColor,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: bandColor,
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
}
