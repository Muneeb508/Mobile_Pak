import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/exchange_match.dart';

class ExchangeMatchCard extends StatelessWidget {
  final ExchangeMatch match;
  final VoidCallback? onQuickExchange;
  final bool compact;

  const ExchangeMatchCard({
    Key? key,
    required this.match,
    this.onQuickExchange,
    this.compact = true,
  }) : super(key: key);

  Color _getScoreBadgeColor(int score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.accent;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = compact ? 220.0 : double.infinity;

    return SizedBox(
      width: cardWidth,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with score badge
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
                      topRight: Radius.circular(AppDimensions.borderRadiusLarge),
                    ),
                  ),
                  child: match.candidate.images.isNotEmpty
                      ? Image.network(
                          match.candidate.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, color: AppColors.secondary, size: 40);
                          },
                        )
                      : Icon(Icons.image, color: AppColors.secondary, size: 40),
                ),
                // Score badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getScoreBadgeColor(match.matchScore),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${match.matchScore}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Match',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    match.candidate.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppDimensions.gapSmall),
                  // Price
                  Text(
                    match.candidate.formattedPrice,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  // Match reasons
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: match.matchReasons
                        .map((reason) => _ReasonChip(label: reason))
                        .toList(),
                  ),
                  // Cash top-up row
                  if (match.cashTopUp != null) ...[
                    SizedBox(height: 6),
                    _CashTopUpRow(cashDifference: match.cashTopUp!),
                  ],
                  SizedBox(height: 8),
                  // Action button
                  if (onQuickExchange != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onQuickExchange,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Quick Exchange',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
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
}

class _ReasonChip extends StatelessWidget {
  final String label;

  const _ReasonChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: AppColors.accent,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _CashTopUpRow extends StatelessWidget {
  final int cashDifference;

  const _CashTopUpRow({required this.cashDifference});

  @override
  Widget build(BuildContext context) {
    final isPayExtra = cashDifference > 0;
    final formattedAmount = cashDifference.abs().toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        );

    return Row(
      children: [
        Icon(
          isPayExtra ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: isPayExtra ? AppColors.warning : AppColors.success,
        ),
        SizedBox(width: 4),
        Expanded(
          child: Text(
            isPayExtra ? 'Pay Rs $formattedAmount' : 'Receive Rs $formattedAmount',
            style: TextStyle(
              fontSize: 12,
              color: isPayExtra ? AppColors.warning : AppColors.success,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
