import 'package:get/get.dart';

class BrowseController extends GetxController {
  final Rx<String?> selectedFilter = Rx<String?>(null);
  final RxString searchQuery = ''.obs;

  void setFilter(String? filter) {
    selectedFilter.value = filter;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
