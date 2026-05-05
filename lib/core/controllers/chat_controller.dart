import 'package:get/get.dart';
import '../../data/models/chat_message_model.dart';
import '../../data/models/product_model.dart';

class ChatController extends GetxController {
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isTyping = false.obs;
  final RxString lastQuickReplySentId = ''.obs;

  void sendMessage(String text, {bool isQuickReply = false}) {
    if (text.isEmpty) return;

    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
      type: isQuickReply ? 'quick_reply' : 'text',
    );

    messages.add(message);
    lastQuickReplySentId.value = message.id;

    if (isQuickReply) {
      Future.delayed(const Duration(milliseconds: 500), () {
        lastQuickReplySentId.value = '';
      });
    }

    // Simulate seller typing and replying
    isTyping.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      messages.add(ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString() + "_reply",
        senderId: 'seller',
        text: _getAutoReply(text),
        timestamp: DateTime.now(),
        type: 'text',
      ));
      isTyping.value = false;
    });
  }

  String _getAutoReply(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('available')) return 'Yes, it is still available!';
    if (lower.contains('price') || lower.contains('last')) return 'The price is slightly negotiable. Make an offer!';
    if (lower.contains('location')) return 'I am located in the city center. We can meet at a safe public place.';
    if (lower.contains('exchange')) return 'I might be open to an exchange. What do you have?';
    return 'Thanks for reaching out! Give me a moment and I will get back to you.';
  }

  List<String> getQuickReplies(Product? product) {
    const alwaysShown = [
      'Is this available?',
      'Final price?',
      'Location?',
      'PTA approved?',
      'Box available?',
    ];

    if (product == null) return alwaysShown;

    final listingType = product.listingType;
    if (listingType == 'exchange' || listingType == 'both') {
      return [...alwaysShown, 'Exchange possible?'];
    }

    return alwaysShown;
  }

  void loadConversation(String sellerName) {
    messages.clear();
    // Add initial mock message from seller
    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'seller',
      text: 'Hi there! Let me know if you have any questions about the listing.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: 'text',
    ));
  }
}
