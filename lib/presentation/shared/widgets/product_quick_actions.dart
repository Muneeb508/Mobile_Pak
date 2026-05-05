import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/wishlist_controller.dart';
import '../../../data/models/product_model.dart';
import '../../chat/chat_screen.dart';
import '../../exchange/exchange_screen.dart';

enum QuickActionContext {
  browse,     // Chat + Save (no Exchange)
  exchange,   // Exchange only
  detail,     // Chat + Exchange + Save
}

class ProductQuickActions extends StatefulWidget {
  final Product product;
  final bool showLabels;
  final Axis direction;
  final QuickActionContext context;

  const ProductQuickActions({
    Key? key,
    required this.product,
    this.showLabels = false,
    this.direction = Axis.horizontal,
    this.context = QuickActionContext.detail,
  }) : super(key: key);

  @override
  State<ProductQuickActions> createState() => _ProductQuickActionsState();
}

class _ProductQuickActionsState extends State<ProductQuickActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final wishlistController = Get.find<WishlistController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onActionPressed(VoidCallback action) {
    _animationController.forward().then((_) {
      _animationController.reverse();
      action();
    });
  }

  void _openQuickChat() {
    _onActionPressed(() {
      Get.to(
        () => ChatScreen(
          product: widget.product,
          sellerName: widget.product.seller.name,
        ),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _offerExchange() {
    if (!widget.product.isExchangeAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This product does not support exchange'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _onActionPressed(() {
      Get.to(
        () => const ExchangeScreen(),
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _toggleWishlist() {
    _onActionPressed(() {
      wishlistController.toggleWishlist(widget.product.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.horizontal
        ? _buildHorizontalActions()
        : _buildVerticalActions();
  }

  Widget _buildHorizontalActions() {
    final buttons = _getVisibleButtons();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          buttons.length,
          (index) {
            final isLast = index == buttons.length - 1;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buttons[index],
                if (!isLast) SizedBox(width: AppDimensions.gapSmall),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _getVisibleButtons() {
    final buttons = <Widget>[];

    // Always show chat for browse and detail contexts
    if (widget.context == QuickActionContext.browse ||
        widget.context == QuickActionContext.detail) {
      buttons.add(
        _QuickActionButton(
          icon: Icons.chat_outlined,
          label: 'Chat',
          onPressed: _openQuickChat,
          animationController: _animationController,
        ),
      );
    }

    // Show exchange for exchange and detail contexts
    if (widget.context == QuickActionContext.exchange ||
        widget.context == QuickActionContext.detail) {
      buttons.add(
        _QuickActionButton(
          icon: Icons.swap_horiz,
          label: 'Exchange',
          onPressed: _offerExchange,
          animationController: _animationController,
          isEnabled: widget.product.isExchangeAvailable,
        ),
      );
    }

    // Always show save for browse and detail contexts
    if (widget.context == QuickActionContext.browse ||
        widget.context == QuickActionContext.detail) {
      buttons.add(
        Obx(() {
          final isWishlisted = wishlistController.isWishlisted(widget.product.id);
          return _QuickActionButton(
            icon: isWishlisted ? Icons.favorite : Icons.favorite_outline,
            label: 'Save',
            onPressed: _toggleWishlist,
            animationController: _animationController,
            iconColor: isWishlisted ? AppColors.error : null,
          );
        }),
      );
    }

    return buttons;
  }

  Widget _buildVerticalActions() {
    final buttons = <Widget>[];

    if (widget.context == QuickActionContext.browse ||
        widget.context == QuickActionContext.detail) {
      buttons.add(
        _QuickActionButton(
          icon: Icons.chat_outlined,
          label: 'Chat',
          onPressed: _openQuickChat,
          animationController: _animationController,
          showLabel: widget.showLabels,
        ),
      );
    }

    if (widget.context == QuickActionContext.exchange ||
        widget.context == QuickActionContext.detail) {
      buttons.add(
        _QuickActionButton(
          icon: Icons.swap_horiz,
          label: 'Exchange',
          onPressed: _offerExchange,
          animationController: _animationController,
          isEnabled: widget.product.isExchangeAvailable,
          showLabel: widget.showLabels,
        ),
      );
    }

    if (widget.context == QuickActionContext.browse ||
        widget.context == QuickActionContext.detail) {
      buttons.add(
        Obx(() {
          final isWishlisted = wishlistController.isWishlisted(widget.product.id);
          return _QuickActionButton(
            icon: isWishlisted ? Icons.favorite : Icons.favorite_outline,
            label: 'Save',
            onPressed: _toggleWishlist,
            animationController: _animationController,
            iconColor: isWishlisted ? AppColors.error : null,
            showLabel: widget.showLabels,
          );
        }),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        buttons.length,
        (index) {
          final isLast = index == buttons.length - 1;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buttons[index],
              if (!isLast) SizedBox(height: AppDimensions.gapSmall),
            ],
          );
        },
      ),
    );
  }
}

class _QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final AnimationController animationController;
  final bool isEnabled;
  final Color? iconColor;
  final bool showLabel;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.animationController,
    this.isEnabled = true,
    this.iconColor,
    this.showLabel = false,
  });

  @override
  State<_QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<_QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _localController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _localController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _localController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    _localController.forward();
  }

  void _onTapUp() {
    _localController.reverse();
    if (widget.isEnabled) {
      widget.onPressed();
    }
  }

  void _onTapCancel() {
    _localController.reverse();
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
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.circle,
            color: widget.isEnabled ? AppColors.card : AppColors.background,
            child: InkWell(
              onTap: widget.isEnabled ? widget.onPressed : null,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingSmall),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.icon,
                      size: AppDimensions.iconSize,
                      color: widget.iconColor ??
                          (widget.isEnabled ? AppColors.primary : AppColors.secondary),
                    ),
                    if (widget.showLabel) ...[
                      SizedBox(height: 4),
                      Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
