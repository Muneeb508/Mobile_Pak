import 'package:get/get.dart';
import '../../data/models/product_model.dart';

class WishlistController extends GetxController {
  // Store product IDs that are in the wishlist
  final RxSet<String> wishlistedIds = <String>{}.obs;

  bool isWishlisted(String productId) {
    return wishlistedIds.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (wishlistedIds.contains(productId)) {
      wishlistedIds.remove(productId);
    } else {
      wishlistedIds.add(productId);
    }
  }
}
