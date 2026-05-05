import 'package:get/get.dart';
import '../../data/models/smart_tag.dart';
import '../../data/models/product_model.dart';
import '../../services/smart_tag_service.dart';

class SmartTagController extends GetxController {
  final RxSet<TagType> selectedTags = <TagType>{}.obs;
  final RxBool isFiltering = false.obs;

  /// Get smart tags for a product
  List<SmartTag> getProductTags(Product product) {
    return SmartTagService.generateTags(product);
  }

  /// Get tags by category for a product
  List<SmartTag> getTagsByCategory(Product product, TagCategory category) {
    return SmartTagService.getTagsByCategory(product, category);
  }

  /// Check if product has a specific tag
  bool hasTag(Product product, TagType tagType) {
    return SmartTagService.hasTag(product, tagType);
  }

  /// Toggle tag selection for filtering
  void toggleTag(TagType tagType) {
    if (selectedTags.contains(tagType)) {
      selectedTags.remove(tagType);
    } else {
      selectedTags.add(tagType);
    }

    isFiltering.value = selectedTags.isNotEmpty;
  }

  /// Clear all selected tags
  void clearFilters() {
    selectedTags.clear();
    isFiltering.value = false;
  }

  /// Select multiple tags
  void selectTags(List<TagType> tags) {
    selectedTags.assignAll(tags);
    isFiltering.value = selectedTags.isNotEmpty;
  }

  /// Filter products by selected tags
  List<Product> filterProducts(List<Product> products) {
    if (selectedTags.isEmpty) {
      return products;
    }

    return SmartTagService.filterByTags(
      products,
      selectedTags.toList(),
    );
  }

  /// Get popular tags from a list of products
  List<SmartTag> getPopularTags(List<Product> products, {int limit = 10}) {
    return SmartTagService.getPopularTags(products, limit: limit);
  }

  /// Get tag frequency across products
  Map<TagType, int> getTagFrequency(List<Product> products) {
    return SmartTagService.getTagFrequency(products);
  }

  /// Check if a tag is selected
  bool isTagSelected(TagType tagType) {
    return selectedTags.contains(tagType);
  }

  /// Get number of active filters
  int get activeFilterCount => selectedTags.length;

  /// Check if any filters are active
  bool get hasActiveFilters => selectedTags.isNotEmpty;
}
