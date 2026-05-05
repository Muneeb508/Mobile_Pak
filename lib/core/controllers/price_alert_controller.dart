import 'package:get/get.dart';
import '../../data/models/price_alert_model.dart';
import '../../data/models/product_model.dart';
import '../../services/price_alert_service.dart';

class PriceAlertController extends GetxController {
  final RxSet<String> watchedProductIds = <String>{}.obs;
  final RxList<PriceAlertModel> userAlerts = <PriceAlertModel>[].obs;

  Future<void> loadUserAlerts(String userId) async {
    try {
      final alerts = await PriceAlertService.getUserAlerts(userId);
      userAlerts.value = alerts;
      watchedProductIds.value = alerts.map((a) => a.productId).toSet();
    } catch (e) {
      print('Error loading alerts: $e');
    }
  }

  Future<void> toggleAlert(String userId, Product product) async {
    try {
      final isCurrentlyWatching = isWatching(product.id);

      if (isCurrentlyWatching) {
        await PriceAlertService.removeAlert(userId, product.id);
        watchedProductIds.remove(product.id);
        userAlerts.removeWhere((a) => a.productId == product.id);
      } else {
        await PriceAlertService.addAlert(userId, product);
        watchedProductIds.add(product.id);
        final alert = PriceAlertModel(
          id: '$userId-${product.id}',
          userId: userId,
          productId: product.id,
          productTitle: product.title,
          watchedPrice: product.priceValue,
          targetDropPercent: 5,
          isActive: true,
          createdAt: DateTime.now(),
        );
        userAlerts.add(alert);
      }
      update();
    } catch (e) {
      print('Error toggling alert: $e');
    }
  }

  bool isWatching(String productId) {
    return watchedProductIds.contains(productId);
  }

  Future<void> checkAlertsForProduct(String userId, Product product) async {
    if (isWatching(product.id)) {
      await PriceAlertService.checkAndNotify(userId, product);
      await loadUserAlerts(userId);
    }
  }
}
