import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/controllers/map_controller.dart';
import '../../../data/models/product_model.dart';
import '../../../services/location_service.dart';
import '../../../services/map_cluster_service.dart';
import '../../product_detail/product_detail_screen.dart';
import 'map_price_pin.dart';
import 'map_product_preview.dart';

class BrowseMapView extends StatefulWidget {
  final List<Product> products;

  const BrowseMapView({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  State<BrowseMapView> createState() => _BrowseMapViewState();
}

class _BrowseMapViewState extends State<BrowseMapView> {
  late AppMapController mapCtrl;

  @override
  void initState() {
    super.initState();
    mapCtrl = Get.find<AppMapController>();
    // Build initial clusters after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapCtrl.rebuildInitialClusters(widget.products);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildFlutterMap(),
        _buildLocationDeniedBanner(),
        _buildMyLocationButton(),
        _buildPreviewCard(),
      ],
    );
  }

  Widget _buildFlutterMap() {
    return fm.FlutterMap(
      mapController: mapCtrl.flutterMapController,
      options: fm.MapOptions(
        initialCenter: LocationService.kPakistanCenter,
        initialZoom: 6.0,
        maxZoom: 18.0,
        minZoom: 4.0,
        onPositionChanged: (position, _) {
          mapCtrl.onMapMoved(position.zoom ?? 6.0, widget.products);
        },
        onTap: (_, __) => mapCtrl.dismissPreview(),
      ),
      children: [
        fm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.mobilepak.app',
        ),
        Obx(() => fm.MarkerLayer(
          markers: _buildMarkers(),
        )),
      ],
    );
  }

  List<fm.Marker> _buildMarkers() {
    return mapCtrl.clusters.map((cluster) {
      return fm.Marker(
        point: cluster.center,
        width: cluster.isSingle ? 90 : 44,
        height: cluster.isSingle ? 44 : 44,
        child: Obx(() => MapPricePin(
          cluster: cluster,
          isSelected: mapCtrl.selectedProduct.value?.id ==
              cluster.representative.id,
          onTap: () => mapCtrl.selectProduct(cluster.representative),
        )),
      );
    }).toList();
  }

  Widget _buildLocationDeniedBanner() {
    return Obx(() => mapCtrl.locationDenied.value
        ? Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.warning.withOpacity(0.9),
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.padding,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Location access denied — showing Pakistan-wide listings',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => mapCtrl.locationDenied.value = false,
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  Widget _buildMyLocationButton() {
    return Positioned(
      bottom: 100,
      right: AppDimensions.padding,
      child: Obx(() => FloatingActionButton(
        onPressed: mapCtrl.fetchUserLocation,
        backgroundColor: AppColors.accent,
        mini: true,
        child: mapCtrl.isLocating.value
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.my_location, color: Colors.white, size: 18),
      )),
    );
  }

  Widget _buildPreviewCard() {
    return Obx(() => AnimatedPositioned(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      bottom: mapCtrl.isPreviewVisible.value ? 0 : -300,
      left: 0,
      right: 0,
      child: mapCtrl.selectedProduct.value != null
          ? MapProductPreview(
              product: mapCtrl.selectedProduct.value!,
              onDismiss: mapCtrl.dismissPreview,
              onViewListing: () {
                mapCtrl.dismissPreview();
                Get.to(() => ProductDetailScreen(
                  product: mapCtrl.selectedProduct.value!,
                ));
              },
            )
          : const SizedBox.shrink(),
    ));
  }
}
