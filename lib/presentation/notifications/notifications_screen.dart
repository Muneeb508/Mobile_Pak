import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../data/models/notification_model.dart';
import '../../core/controllers/auth_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late String _userId;

  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();
    _userId = authController.currentUser.value?.id ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          elevation: 0,
        ),
        body: const Center(
          child: Text('Please log in to see notifications'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: _userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final notifications = snapshot.data?.docs ?? [];

          if (notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = NotificationModel.fromJson(
                notifications[index].data() as Map<String, dynamic>,
              );

              return _NotificationTile(notification: notif);
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPriceDrop = notification.type == 'price_drop';
    final borderColor = isPriceDrop ? Colors.green[200] : Colors.blue[200];
    final backgroundColor = isPriceDrop ? Colors.green[50] : Colors.blue[50];
    final iconColor = isPriceDrop ? Colors.green[700] : Colors.blue[700];

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.padding,
        vertical: AppDimensions.gapMedium,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor!),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: ListTile(
        leading: Icon(
          isPriceDrop ? Icons.trending_down : Icons.info,
          color: iconColor,
        ),
        title: Text(
          notification.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(notification.message),
        trailing: Text(
          _formatTime(notification.createdAt),
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        onTap: () {
          if (notification.relatedProductId != null) {
            // Navigate to product detail if needed
            Navigator.pop(context);
            // Future: navigate to product page
          }
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
