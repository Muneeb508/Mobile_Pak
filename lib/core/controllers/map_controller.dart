import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import '../../data/models/product_model.dart';
import '../../services/location_service.dart';
import '../../services/map_cluster_service.dart';

class AppMapController extends GetxController {
  final RxBool isMapView = false.obs;
  final Rx<LatLng?> userPosition = Rx<LatLng?>(null);
  final RxBool isLocating = false.obs;
  final RxBool locationDenied = false.obs;
  late final fm.MapController flutterMapController;
  final RxDouble mapZoom = 6.0.obs;
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final RxBool isPreviewVisible = false.obs;
  final RxList<MapCluster> clusters = <MapCluster>[].obs;

  @override
  void onInit() {
    super.onInit();
    flutterMapController = fm.MapController();
  }

  @override
  void onClose() {
    flutterMapController.dispose();
    super.onClose();
  }

  void toggleView() {
    isMapView.value = !isMapView.value;
    if (isMapView.value && userPosition.value == null) {
      fetchUserLocation();
    }
  }

  Future<void> fetchUserLocation() async {
    isLocating.value = true;
    locationDenied.value = false;

    final pos = await LocationService.getCurrentPosition();
    if (pos != null) {
      userPosition.value = pos;
      locationDenied.value = false;
      Future.delayed(const Duration(milliseconds: 100), () {
        flutterMapController.move(pos, 10.0);
        mapZoom.value = 10.0;
      });
    } else {
      locationDenied.value = true;
      userPosition.value = LocationService.kPakistanCenter;
      Future.delayed(const Duration(milliseconds: 100), () {
        flutterMapController.move(LocationService.kPakistanCenter, 6.0);
        mapZoom.value = 6.0;
      });
    }
    isLocating.value = false;
  }

  void onMapMoved(double zoom, List<Product> allProducts) {
    mapZoom.value = zoom;
    _rebuildClusters(allProducts, zoom);
  }

  void selectProduct(Product product) {
    selectedProduct.value = product;
    isPreviewVisible.value = true;
  }

  void dismissPreview() {
    isPreviewVisible.value = false;
    Future.delayed(const Duration(milliseconds: 300), () {
      selectedProduct.value = null;
    });
  }

  void _rebuildClusters(List<Product> products, double zoom) {
    clusters.value = MapClusterService.cluster(products, zoom);
  }

  void rebuildInitialClusters(List<Product> products) {
    _rebuildClusters(products, mapZoom.value);
  }
}
