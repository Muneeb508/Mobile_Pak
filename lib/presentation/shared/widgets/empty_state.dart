import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

enum EmptyStateType {
  noSearchResults,
  emptyWishlist,
  noListings,
  noNotifications,
  noMessages,
  noExchangeOffers,
}

class EmptyState extends StatelessWidget {
  final EmptyStateType type;
  final String? customTitle;
  final String? customSubtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    Key? key,
    required this.type,
    this.customTitle,
    this.customSubtitle,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.padding * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                config.icon,
                size: 48,
                color: AppColors.accent.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: AppDimensions.padding),
            Text(
              customTitle ?? config.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: AppDimensions.gapMedium),
            Text(
              customSubtitle ?? config.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            if (onAction != null) ...[
              SizedBox(height: AppDimensions.padding),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel ?? 'Browse Listings'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _EmptyStateConfig _getConfig() {
    switch (type) {
      case EmptyStateType.noSearchResults:
        return _EmptyStateConfig(
          icon: Icons.search_off,
          title: 'No Results Found',
          subtitle: 'Try different keywords or clear your filters to see more listings.',
        );
      case EmptyStateType.emptyWishlist:
        return _EmptyStateConfig(
          icon: Icons.favorite_outline,
          title: 'Your Wishlist is Empty',
          subtitle: 'Tap the heart icon on any phone to save it here for later.',
        );
      case EmptyStateType.noListings:
        return _EmptyStateConfig(
          icon: Icons.phone_android_outlined,
          title: 'No Listings Yet',
          subtitle: 'Be the first to sell in your area! Tap the + button to list your phone.',
        );
      case EmptyStateType.noNotifications:
        return _EmptyStateConfig(
          icon: Icons.notifications_off_outlined,
          title: 'No Notifications',
          subtitle: 'You\'ll see price drops and alerts here when you watch products.',
        );
      case EmptyStateType.noMessages:
        return _EmptyStateConfig(
          icon: Icons.chat_bubble_outline,
          title: 'No Messages',
          subtitle: 'Start a conversation with a seller to see your messages here.',
        );
      case EmptyStateType.noExchangeOffers:
        return _EmptyStateConfig(
          icon: Icons.swap_horiz,
          title: 'No Exchange Offers',
          subtitle: 'Offers for your phone will appear here when you list with exchange enabled.',
        );
    }
  }
}

class _EmptyStateConfig {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyStateConfig({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
