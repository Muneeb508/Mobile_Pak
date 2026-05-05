import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// Reusable quick action button for product cards
/// Supports various sizes and styles
class QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool showLabel;

  const QuickActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.iconColor,
    this.size = 40,
    this.showLabel = false,
  }) : super(key: key);

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown() {
    if (widget.isEnabled) {
      _controller.forward();
    }
  }

  void _onTapUp() {
    _controller.reverse();
    if (widget.isEnabled) {
      widget.onPressed();
    }
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
        child: Tooltip(
          message: widget.label,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.backgroundColor ?? AppColors.card,
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
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isEnabled ? widget.onPressed : null,
                customBorder: const CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    widget.icon,
                    size: widget.size * 0.5,
                    color: widget.iconColor ??
                        (widget.isEnabled ? AppColors.primary : AppColors.secondary),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact quick actions for list views or minimal layouts
class CompactQuickActions extends StatelessWidget {
  final VoidCallback onChat;
  final VoidCallback onExchange;
  final VoidCallback onSave;
  final bool canExchange;
  final bool isSaved;

  const CompactQuickActions({
    Key? key,
    required this.onChat,
    required this.onExchange,
    required this.onSave,
    this.canExchange = true,
    this.isSaved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuickActionButton(
          icon: Icons.chat_outlined,
          label: 'Chat',
          onPressed: onChat,
          size: 36,
        ),
        SizedBox(width: AppDimensions.gapSmall),
        QuickActionButton(
          icon: Icons.swap_horiz,
          label: 'Exchange',
          onPressed: onExchange,
          isEnabled: canExchange,
          size: 36,
        ),
        SizedBox(width: AppDimensions.gapSmall),
        QuickActionButton(
          icon: isSaved ? Icons.favorite : Icons.favorite_outline,
          label: 'Save',
          onPressed: onSave,
          iconColor: isSaved ? AppColors.error : null,
          size: 36,
        ),
      ],
    );
  }
}
