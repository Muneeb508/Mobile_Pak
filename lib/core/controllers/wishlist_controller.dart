import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/product_model.dart';

class WishlistController extends GetxController {
  final _storage = GetStorage();
  final RxSet<String> wishlistedIds = <String>{}.obs;
  final RxList<Product> wishlistedProducts = <Product>[].obs;

  static const String _storageKey = 'wishlisted_ids';

  @override
  void onReady() {
    super.onReady();
    _loadFromStorage();
  }

  void _loadFromStorage() {
    try {
      final stored = _storage.read<List<dynamic>>(_storageKey);
      if (stored != null) {
        wishlistedIds.addAll(stored.cast<String>());
      }
    } catch (e) {
      print('Error loading wishlist from storage: $e');
    }
  }

  void _saveToStorage() {
    try {
      _storage.write(_storageKey, wishlistedIds.toList());
    } catch (e) {
      print('Error saving wishlist to storage: $e');
    }
  }

  bool isWishlisted(String productId) {
    return wishlistedIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (wishlistedIds.contains(productId)) {
      wishlistedIds.remove(productId);
    } else {
      wishlistedIds.add(productId);
    }
    _saveToStorage();
  }

  void toggleWishlistWithFeedback(String productId, {String? productTitle}) {
    final wasAdded = !wishlistedIds.contains(productId);
    toggleWishlist(productId);

    if (wasAdded) {
      Get.snackbar(
        'Added to Wishlist',
        productTitle ?? 'Item saved to wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    } else {
      Get.snackbar(
        'Removed from Wishlist',
        productTitle ?? 'Item removed from wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700]!,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
      );
    }
  }

  int get itemCount => wishlistedIds.length;
}
