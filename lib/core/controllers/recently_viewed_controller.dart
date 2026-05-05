import 'package:get/get.dart';
import '../../data/models/recently_viewed_item.dart';
import '../../services/recently_viewed_service.dart';
import '../../data/models/product_model.dart';

class RecentlyViewedController extends GetxController {
  final RecentlyViewedService _service = RecentlyViewedService();

  final RxList<RecentlyViewedItem> recentlyViewedItems = <RecentlyViewedItem>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecentlyViewed();
  }

  // Load recently viewed items from storage
  Future<void> loadRecentlyViewed() async {
    try {
      isLoading.value = true;
      final items = await _service.getRecentlyViewedItems();
      recentlyViewedItems.assignAll(items);
    } catch (e) {
      print('Error loading recently viewed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add a viewed product
  Future<void> addViewedProduct(Product product) async {
    try {
      final item = RecentlyViewedItem(
        productId: product.id,
        title: product.title,
        price: product.priceValue,
        imageUrl: product.images.isNotEmpty ? product.images.first : '',
        location: product.location,
        viewedAt: DateTime.now(),
      );

      await _service.addViewedProduct(item);
      await loadRecentlyViewed();
    } catch (e) {
      print('Error adding viewed product: $e');
    }
  }

  // Clear all recently viewed items
  Future<void> clearRecentlyViewed() async {
    try {
      await _service.clearRecentlyViewed();
      recentlyViewedItems.clear();
    } catch (e) {
      print('Error clearing recently viewed: $e');
    }
  }

  // Remove a specific item
  Future<void> removeItem(String productId) async {
    try {
      await _service.removeItem(productId);
      recentlyViewedItems.removeWhere((item) => item.productId == productId);
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Get recently viewed items (returns list, not observable)
  List<RecentlyViewedItem> getItems() => recentlyViewedItems;

  // Check if has recently viewed items
  bool get hasItems => recentlyViewedItems.isNotEmpty;

  // Get count
  int get itemCount => recentlyViewedItems.length;
}
