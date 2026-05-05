import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';

class QuickReplyChips extends StatefulWidget {
  final Product? product;
  final Function(String) onSend;
  final bool visible;

  const QuickReplyChips({
    Key? key,
    required this.product,
    required this.onSend,
    required this.visible,
  }) : super(key: key);

  @override
  State<QuickReplyChips> createState() => _QuickReplyChipsState();
}

class _QuickReplyChipsState extends State<QuickReplyChips> {
  String? _animatingChipText;

  List<String> _getQuickReplies() {
    const alwaysShown = [
      'Is this available?',
      'Final price?',
      'Location?',
      'PTA approved?',
      'Box available?',
    ];

    if (widget.product == null) return alwaysShown;

    final listingType = widget.product!.listingType;
    if (listingType == 'exchange' || listingType == 'both') {
      return [...alwaysShown, 'Exchange possible?'];
    }

    return alwaysShown;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: widget.visible
            ? Container(
                height: 44,
                color: AppColors.background,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.border),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.padding,
                      vertical: AppDimensions.paddingSmall,
                    ),
                    child: Row(
                      children: [
                        ..._getQuickReplies().map((chip) {
                          final isAnimating =
                              _animatingChipText == chip;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: AppDimensions.gapSmall,
                            ),
                            child: _buildChip(chip, isAnimating),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildChip(String text, bool isAnimating) {
    return AnimatedScale(
      scale: isAnimating ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: GestureDetector(
        onTap: () async {
          setState(() => _animatingChipText = text);
          widget.onSend(text);
          await Future.delayed(const Duration(milliseconds: 150));
          if (mounted) {
            setState(() => _animatingChipText = null);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: AppDimensions.paddingSmall,
          ),
          decoration: BoxDecoration(
            color: isAnimating ? AppColors.accent : AppColors.card,
            border: Border.all(
              color: isAnimating ? AppColors.accent : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isAnimating ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
