import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/price_alert_model.dart';
import '../data/models/product_model.dart';
import '../data/models/notification_model.dart';

class PriceAlertService {
  static const String _alertsCollection = 'price_alerts';
  static const String _notificationsCollection = 'notifications';

  static Future<void> addAlert(String userId, Product product) async {
    try {
      final alertId = '$userId-${product.id}';
      final alert = PriceAlertModel(
        id: alertId,
        userId: userId,
        productId: product.id,
        productTitle: product.title,
        watchedPrice: product.priceValue,
        targetDropPercent: 5,
        isActive: true,
        createdAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection(_alertsCollection)
          .doc(alertId)
          .set(alert.toJson());
    } catch (e) {
      throw Exception('Failed to add price alert: $e');
    }
  }

  static Future<void> removeAlert(String userId, String productId) async {
    try {
      final alertId = '$userId-$productId';
      await FirebaseFirestore.instance
          .collection(_alertsCollection)
          .doc(alertId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove price alert: $e');
    }
  }

  static Future<bool> isWatching(String userId, String productId) async {
    try {
      final alertId = '$userId-$productId';
      final doc = await FirebaseFirestore.instance
          .collection(_alertsCollection)
          .doc(alertId)
          .get();
      return doc.exists && (doc['isActive'] as bool? ?? true);
    } catch (e) {
      return false;
    }
  }

  static Future<List<PriceAlertModel>> getUserAlerts(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(_alertsCollection)
          .where('userId', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => PriceAlertModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user alerts: $e');
    }
  }

  static Future<void> checkAndNotify(
    String userId,
    Product product,
  ) async {
    try {
      final alert = await _getAlert(userId, product.id);
      if (alert == null) return;

      if (isPriceDrop(alert.watchedPrice, product.priceValue, alert.targetDropPercent)) {
        await _createNotification(userId, alert, product.priceValue);
        await _deactivateAlert(alert.id);
      }
    } catch (e) {
      print('Error checking price drop: $e');
    }
  }

  static bool isPriceDrop(int watchedPrice, int currentPrice, int dropThreshold) {
    final targetPrice = (watchedPrice * (1 - dropThreshold / 100)).round();
    return currentPrice <= targetPrice;
  }

  static int calculateDropPercent(int watchedPrice, int currentPrice) {
    if (watchedPrice == 0) return 0;
    return (((watchedPrice - currentPrice) / watchedPrice) * 100).toInt();
  }

  static Future<PriceAlertModel?> _getAlert(String userId, String productId) async {
    try {
      final alertId = '$userId-$productId';
      final doc = await FirebaseFirestore.instance
          .collection(_alertsCollection)
          .doc(alertId)
          .get();

      if (doc.exists) {
        return PriceAlertModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<void> _createNotification(
    String userId,
    PriceAlertModel alert,
    int currentPrice,
  ) async {
    try {
      final dropPercent = calculateDropPercent(alert.watchedPrice, currentPrice);
      final notification = NotificationModel(
        id: FirebaseFirestore.instance.collection(_notificationsCollection).doc().id,
        userId: userId,
        title: 'Price Drop: ${alert.productTitle}',
        message: 'Price dropped by $dropPercent%! Now PKR ${currentPrice.toStringAsFixed(0)}',
        type: 'price_drop',
        createdAt: DateTime.now(),
        isRead: false,
        relatedProductId: alert.productId,
      );

      await FirebaseFirestore.instance
          .collection(_notificationsCollection)
          .doc(notification.id)
          .set(notification.toJson());
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  static Future<void> _deactivateAlert(String alertId) async {
    try {
      await FirebaseFirestore.instance
          .collection(_alertsCollection)
          .doc(alertId)
          .update({'isActive': false});
    } catch (e) {
      print('Failed to deactivate alert: $e');
    }
  }
}
