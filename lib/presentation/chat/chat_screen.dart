import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/controllers/chat_controller.dart';
import '../../data/models/product_model.dart';
import '../product_detail/product_detail_screen.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final Product? product;
  final String sellerName;

  const ChatScreen({
    Key? key,
    this.product,
    this.sellerName = 'Seller',
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final chatController = Get.find<ChatController>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    chatController.loadConversation(widget.sellerName);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.sellerName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.gapMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.sellerName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Online',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Product context card
          if (widget.product != null)
            _buildProductContextCard(),

          // Messages list
          Expanded(
            child: Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });
              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController
                      .messages[chatController.messages.length - 1 - index];
                  final isSent = message.senderId == 'me';
                  return MessageBubble(
                    message: message,
                    isSent: isSent,
                  );
                },
              );
            }),
          ),

          // Input bar with quick reply chips
          ChatInputBar(product: widget.product),
        ],
      ),
    );
  }

  Widget _buildProductContextCard() {
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(
        product: widget.product!,
      )),
      child: Container(
        margin: EdgeInsets.all(AppDimensions.padding),
        padding: EdgeInsets.all(AppDimensions.paddingSmall),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
              ),
              child: widget.product!.images.isNotEmpty
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadius),
                      child: Image.network(
                        widget.product!.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image, color: AppColors.secondary);
                        },
                      ),
                    )
                  : Icon(Icons.image, color: AppColors.secondary),
            ),
            SizedBox(width: AppDimensions.gapMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product!.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    widget.product!.formattedPrice,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}
