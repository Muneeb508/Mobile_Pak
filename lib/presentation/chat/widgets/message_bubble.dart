import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/chat_message_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isSent;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isSent,
  }) : super(key: key);

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.padding,
            vertical: AppDimensions.gapSmall,
          ),
          child: Align(
            alignment: widget.isSent ? Alignment.centerRight : Alignment.centerLeft,
            child: _buildBubble(),
          ),
        ),
      ),
    );
  }

  Widget _buildBubble() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: AppDimensions.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: widget.isSent ? AppColors.accent : AppColors.card,
        border: widget.isSent
            ? null
            : Border.all(color: AppColors.border),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.borderRadiusLarge),
          topRight: Radius.circular(AppDimensions.borderRadiusLarge),
          bottomLeft: Radius.circular(
            widget.isSent ? AppDimensions.borderRadiusLarge : 4,
          ),
          bottomRight: Radius.circular(
            widget.isSent ? 4 : AppDimensions.borderRadiusLarge,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.message.text,
            style: TextStyle(
              color: widget.isSent ? Colors.white : AppColors.primary,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeago.format(widget.message.timestamp, locale: 'en_short'),
                style: TextStyle(
                  color: widget.isSent
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.secondary,
                  fontSize: 10,
                ),
              ),
              if (widget.isSent) ...[
                SizedBox(width: 4),
                Icon(
                  Icons.done_all,
                  size: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
