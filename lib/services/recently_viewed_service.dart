import 'package:get_storage/get_storage.dart';
import '../data/models/recently_viewed_item.dart';

class RecentlyViewedService {
  static const String _storageKey = 'recently_viewed_items';
  static const int _maxItems = 10; // Limit to latest 10 viewed products

  final GetStorage _storage = GetStorage();

  // Add or update a recently viewed item
  Future<void> addViewedProduct(RecentlyViewedItem item) async {
    try {
      final items = await getRecentlyViewedItems();

      // Remove if already exists (to avoid duplicates)
      items.removeWhere((element) => element.productId == item.productId);

      // Add new item to the beginning
      items.insert(0, item.copyWith(viewedAt: DateTime.now()));

      // Keep only the latest items
      if (items.length > _maxItems) {
        items.removeRange(_maxItems, items.length);
      }

      // Save to storage
      final jsonList = items.map((item) => item.toJson()).toList();
      await _storage.write(_storageKey, jsonList);
    } catch (e) {
      print('Error adding viewed product: $e');
    }
  }

  // Get all recently viewed items
  Future<List<RecentlyViewedItem>> getRecentlyViewedItems() async {
    try {
      final jsonList = _storage.read<List>(_storageKey);

      if (jsonList == null || jsonList.isEmpty) {
        return [];
      }

      // Convert JSON to RecentlyViewedItem objects
      return (jsonList as List)
          .map((item) => RecentlyViewedItem.fromJson(
              Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      print('Error getting recently viewed items: $e');
      return [];
    }
  }

  // Clear all recently viewed items
  Future<void> clearRecentlyViewed() async {
    try {
      await _storage.remove(_storageKey);
    } catch (e) {
      print('Error clearing recently viewed: $e');
    }
  }

  // Remove a specific item
  Future<void> removeItem(String productId) async {
    try {
      final items = await getRecentlyViewedItems();
      items.removeWhere((item) => item.productId == productId);

      final jsonList = items.map((item) => item.toJson()).toList();
      await _storage.write(_storageKey, jsonList);
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Get count of recently viewed items
  Future<int> getItemCount() async {
    final items = await getRecentlyViewedItems();
    return items.length;
  }

  // Check if a product has been viewed
  Future<bool> hasBeenViewed(String productId) async {
    final items = await getRecentlyViewedItems();
    return items.any((item) => item.productId == productId);
  }
}
