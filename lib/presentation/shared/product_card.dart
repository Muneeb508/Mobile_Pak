import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/controllers/wishlist_controller.dart';
import '../../data/models/product_model.dart';
import 'package:get/get.dart';
import 'verified_badge.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onWishlistToggle;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    this.onWishlistToggle,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final wishlistController = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _controller.forward();
  }

  void _onTapUp() {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) => _onTapDown(),
        onTapUp: (_) => _onTapUp(),
        onTapCancel: _onTapCancel,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            color: AppColors.card,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.product.images.isNotEmpty ? widget.product.images.first : '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppColors.background,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.background,
                      child: Icon(Icons.image_not_supported, color: AppColors.secondary),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: AppDimensions.paddingSmall,
                  left: AppDimensions.paddingSmall,
                  child: Wrap(
                    spacing: AppDimensions.gapSmall,
                    children: [
                      if (widget.product.isVerified) VerifiedBadge(),
                      if (widget.product.isHotDeal)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.paddingSmall,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                          ),
                          child: Text(
                            'Hot Deal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: AppDimensions.paddingSmall,
                  right: AppDimensions.paddingSmall,
                  child: GestureDetector(
                    onTap: () {
                      wishlistController.toggleWishlist(widget.product.id);
                      widget.onWishlistToggle?.call();
                    },
                    child: Obx(() {
                      final isWishlisted = wishlistController.isWishlisted(widget.product.id);
                      return Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite : Icons.favorite_outline,
                          color: isWishlisted ? AppColors.error : AppColors.secondary,
                          size: AppDimensions.iconSize,
                        ),
                      );
                    }),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(AppDimensions.padding),
                    color: AppColors.card,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppDimensions.gapSmall),
                        Text(
                          '${widget.product.storage} • PTA ✔ • ${widget.product.batteryHealth}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: AppDimensions.gapSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.product.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                    '${widget.product.distance} away',
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              timeago.format(widget.product.postedAt, locale: 'en_short'),
                              style: TextStyle(
                                color: AppColors.secondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimensions.gapSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.product.formattedPrice,
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (widget.product.acceptedExchangeTiers.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppDimensions.gapSmall,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
                                  border: Border.all(color: AppColors.accent),
                                ),
                                child: Text(
                                  widget.product.exchangeLabel,
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.product.isSuspicious)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding, vertical: 4),
                      color: AppColors.warning.withValues(alpha: 0.9),
                      child: Text(
                        'Unusual Listing',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
