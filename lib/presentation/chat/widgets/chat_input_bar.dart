import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/chat_controller.dart';
import '../../../data/models/product_model.dart';
import 'quick_reply_chips.dart';

class ChatInputBar extends StatefulWidget {
  final Product? product;

  const ChatInputBar({
    Key? key,
    this.product,
  }) : super(key: key);

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  final chatController = Get.find<ChatController>();
  final RxBool _isTyping = false.obs;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    chatController.sendMessage(text, isQuickReply: false);
    _textController.clear();
    _isTyping.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Obx(() => QuickReplyChips(
          product: widget.product,
          visible: !_isTyping.value,
          onSend: (text) {
            chatController.sendMessage(text, isQuickReply: true);
          },
        )),
        Container(
          padding: EdgeInsets.all(AppDimensions.padding),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border(
              top: BorderSide(color: AppColors.border),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file, color: AppColors.secondary),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: 1,
                  maxLength: 500,
                  onChanged: (value) {
                    _isTyping.value = value.isNotEmpty;
                  },
                  onSubmitted: (value) {
                    _sendMessage();
                  },
                  decoration: InputDecoration(
                    hintText: 'Message...',
                    hintStyle: TextStyle(color: AppColors.secondary),
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.gapSmall),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
