import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/smart_tag.dart';
import '../../../data/models/product_model.dart';
import '../../../services/smart_tag_service.dart';

/// Displays smart tags for a product
class SmartTagsWidget extends StatelessWidget {
  final Product product;
  final int maxTags;
  final bool showIcon;
  final bool compact;
  final Axis direction;
  final MainAxisAlignment alignment;
  final EdgeInsets padding;

  const SmartTagsWidget({
    Key? key,
    required this.product,
    this.maxTags = 5,
    this.showIcon = true,
    this.compact = false,
    this.direction = Axis.horizontal,
    this.alignment = MainAxisAlignment.start,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = SmartTagService.generateTags(product).take(maxTags).toList();

    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    if (direction == Axis.horizontal) {
      return _buildHorizontalTags(tags);
    } else {
      return _buildVerticalTags(tags);
    }
  }

  Widget _buildHorizontalTags(List<SmartTag> tags) {
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: alignment,
          children: List.generate(
            tags.length,
            (index) {
              final tag = tags[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < tags.length - 1 ? AppDimensions.gapSmall : 0,
                ),
                child: _SmartTagChip(
                  tag: tag,
                  showIcon: showIcon,
                  compact: compact,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalTags(List<SmartTag> tags) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          tags.length,
          (index) {
            final tag = tags[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < tags.length - 1 ? AppDimensions.gapSmall : 0,
              ),
              child: _SmartTagChip(
                tag: tag,
                showIcon: showIcon,
                compact: compact,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Individual smart tag chip
class _SmartTagChip extends StatelessWidget {
  final SmartTag tag;
  final bool showIcon;
  final bool compact;

  const _SmartTagChip({
    required this.tag,
    this.showIcon = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactTag();
    }
    return _buildFullTag();
  }

  Widget _buildCompactTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tag.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && tag.icon != null) ...[
            Icon(
              tag.icon,
              size: 12,
              color: tag.textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            tag.label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: tag.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tag.backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && tag.icon != null) ...[
            Icon(
              tag.icon,
              size: 14,
              color: tag.textColor,
            ),
            const SizedBox(width: 6),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tag.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: tag.textColor,
                ),
              ),
              if (tag.description != null)
                Text(
                  tag.description!,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w400,
                    color: tag.textColor.withValues(alpha: 0.8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Animated tag chip with hover effect
class AnimatedSmartTag extends StatefulWidget {
  final SmartTag tag;
  final VoidCallback? onTap;
  final bool showIcon;

  const AnimatedSmartTag({
    Key? key,
    required this.tag,
    this.onTap,
    this.showIcon = true,
  }) : super(key: key);

  @override
  State<AnimatedSmartTag> createState() => _AnimatedSmartTagState();
}

class _AnimatedSmartTagState extends State<AnimatedSmartTag>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
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
    widget.onTap?.call();
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: widget.tag.backgroundColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: widget.tag.backgroundColor.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showIcon && widget.tag.icon != null) ...[
                Icon(
                  widget.tag.icon,
                  size: 14,
                  color: widget.tag.textColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.tag.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: widget.tag.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Quick tag filter chips
class TagFilterChips extends StatefulWidget {
  final List<SmartTag> tags;
  final Function(List<SmartTag>) onSelectionChanged;
  final bool singleSelect;

  const TagFilterChips({
    Key? key,
    required this.tags,
    required this.onSelectionChanged,
    this.singleSelect = false,
  }) : super(key: key);

  @override
  State<TagFilterChips> createState() => _TagFilterChipsState();
}

class _TagFilterChipsState extends State<TagFilterChips> {
  final Set<int> _selectedIndices = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.gapSmall,
      runSpacing: AppDimensions.gapSmall,
      children: List.generate(
        widget.tags.length,
        (index) {
          final tag = widget.tags[index];
          final isSelected = _selectedIndices.contains(index);

          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tag.icon != null) ...[
                  Icon(
                    tag.icon,
                    size: 14,
                    color: isSelected ? Colors.white : tag.textColor,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(tag.label),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (widget.singleSelect) {
                  _selectedIndices.clear();
                  if (selected) {
                    _selectedIndices.add(index);
                  }
                } else {
                  if (selected) {
                    _selectedIndices.add(index);
                  } else {
                    _selectedIndices.remove(index);
                  }
                }
              });

              final selectedTags = _selectedIndices
                  .map((i) => widget.tags[i])
                  .toList();
              widget.onSelectionChanged(selectedTags);
            },
            backgroundColor: tag.backgroundColor,
            selectedColor: tag.textColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : tag.textColor,
            ),
          );
        },
      ),
    );
  }
}
