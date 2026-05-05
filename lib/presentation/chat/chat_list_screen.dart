import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/product_model.dart';
import '../../data/models/user_model.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  List<Map<String, dynamic>> _getMockConversations() {
    final now = DateTime.now();

    return [
      {
        'product': Product(
          id: '1',
          title: 'iPhone 14 Pro Max',
          priceValue: 180000,
          images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=iPhone+14+Pro+Max'],
          description: 'Excellent condition',
          location: 'Karachi',
          distance: '2 km',
          specs: ['256GB', '6GB RAM', 'Excellent'],
          seller: UserModel(
            id: 'seller1',
            name: 'Ali Khan',
            avatar: '',
            joinedAt: now.subtract(const Duration(days: 180)),
            rating: 4.8,
            isTrustedSeller: true,
            isCnicVerified: true,
            isPhoneVerified: true,
            totalListings: 45,
            successfulDeals: 45,
          ),
          postedAt: now.subtract(const Duration(days: 5)),
          isVerified: true,
          condition: 'Excellent',
          listingType: 'sell',
        ),
        'sellerName': 'Ali Khan',
        'lastMessage': 'Sure, it\'s available. Available in Karachi.',
        'timestamp': now.subtract(const Duration(minutes: 5)),
        'unread': 1,
      },
      {
        'product': Product(
          id: '2',
          title: 'Samsung Galaxy S24',
          priceValue: 140000,
          images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=Galaxy+S24'],
          description: 'Like new condition',
          location: 'Lahore',
          distance: '3 km',
          specs: ['128GB', '8GB RAM', 'Like New'],
          seller: UserModel(
            id: 'seller2',
            name: 'Fatima Ahmed',
            avatar: '',
            joinedAt: now.subtract(const Duration(days: 240)),
            rating: 4.6,
            isTrustedSeller: true,
            isCnicVerified: true,
            isPhoneVerified: true,
            totalListings: 32,
            successfulDeals: 32,
          ),
          postedAt: now.subtract(const Duration(days: 3)),
          isVerified: true,
          condition: 'Like New',
          listingType: 'sell',
        ),
        'sellerName': 'Fatima Ahmed',
        'lastMessage': 'You: Can you do 135k?',
        'timestamp': now.subtract(const Duration(hours: 2)),
        'unread': 0,
      },
      {
        'product': Product(
          id: '3',
          title: 'OnePlus 12',
          priceValue: 85000,
          images: ['https://dummyimage.com/300x300/cccccc/000000.png&text=OnePlus+12'],
          description: 'Good condition',
          location: 'Islamabad',
          distance: '5 km',
          specs: ['256GB', '12GB RAM', 'Good'],
          seller: UserModel(
            id: 'seller3',
            name: 'Hassan Raza',
            avatar: '',
            joinedAt: now.subtract(const Duration(days: 60)),
            rating: 4.5,
            isTrustedSeller: false,
            isCnicVerified: false,
            isPhoneVerified: true,
            totalListings: 18,
            successfulDeals: 18,
          ),
          postedAt: now.subtract(const Duration(days: 1)),
          isVerified: false,
          condition: 'Good',
          listingType: 'exchange',
        ),
        'sellerName': 'Hassan Raza',
        'lastMessage': 'Is this available?',
        'timestamp': now.subtract(const Duration(days: 1)),
        'unread': 0,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final conversations = _getMockConversations();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Messages'),
        centerTitle: false,
      ),
      body: conversations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_outlined,
                    size: 64,
                    color: AppColors.secondary,
                  ),
                  SizedBox(height: AppDimensions.padding),
                  Text(
                    'No conversations yet',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.border,
                height: 1,
                indent: 72,
              ),
              itemBuilder: (context, index) {
                final conv = conversations[index];
                final product = conv['product'] as Product;
                final sellerName = conv['sellerName'] as String;
                final lastMessage = conv['lastMessage'] as String;
                final timestamp = conv['timestamp'] as DateTime;
                final unread = conv['unread'] as int;

                return GestureDetector(
                  onTap: () => Get.to(
                    () => ChatScreen(
                      product: product,
                      sellerName: sellerName,
                    ),
                  ),
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.padding,
                      vertical: AppDimensions.paddingSmall,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.accent,
                          child: Text(
                            sellerName[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        SizedBox(width: AppDimensions.gapMedium),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      sellerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: AppDimensions.gapSmall),
                                  Text(
                                    _formatTime(timestamp),
                                    style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      lastMessage,
                                      style: TextStyle(
                                        color: unread > 0
                                            ? AppColors.primary
                                            : AppColors.secondary,
                                        fontSize: 13,
                                        fontWeight: unread > 0
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (unread > 0) ...[
                                    SizedBox(width: AppDimensions.gapSmall),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          unread.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
