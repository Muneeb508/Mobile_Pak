import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/controllers/price_alert_controller.dart';
import '../../../core/controllers/auth_controller.dart';
import '../../../data/models/product_model.dart';

class PriceAlertButton extends StatefulWidget {
  final Product product;
  final VoidCallback? onToggle;

  const PriceAlertButton({
    Key? key,
    required this.product,
    this.onToggle,
  }) : super(key: key);

  @override
  State<PriceAlertButton> createState() => _PriceAlertButtonState();
}

class _PriceAlertButtonState extends State<PriceAlertButton> {
  late PriceAlertController alertController;
  late AuthController authController;

  @override
  void initState() {
    super.initState();
    try {
      alertController = Get.find<PriceAlertController>();
      authController = Get.find<AuthController>();
    } catch (e) {
      print('Error initializing price alert button: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      try {
        final watching = alertController.isWatching(widget.product.id);
        return IconButton(
          icon: Icon(
            watching ? Icons.notifications : Icons.notifications_outlined,
            color: watching ? AppColors.accent : Colors.grey[600],
          ),
          onPressed: () => _toggleAlert(context),
        );
      } catch (e) {
        print('Error in PriceAlertButton: $e');
        return IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => _toggleAlert(context),
        );
      }
    });
  }

  void _toggleAlert(BuildContext context) {
    try {
      final userId = authController.currentUser.value?.id ?? '';
      if (userId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in first')),
        );
        return;
      }

      alertController.toggleAlert(userId, widget.product);
      widget.onToggle?.call();

      final newWatchStatus = alertController.isWatching(widget.product.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newWatchStatus ? 'Price alert set!' : 'Price alert removed.',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
