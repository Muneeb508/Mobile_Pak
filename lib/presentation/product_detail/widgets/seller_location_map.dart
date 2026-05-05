import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../data/models/product_model.dart';
import '../../../services/location_service.dart';

class SellerLocationMap extends StatefulWidget {
  final Product product;

  const SellerLocationMap({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<SellerLocationMap> createState() => _SellerLocationMapState();
}

class _SellerLocationMapState extends State<SellerLocationMap> {
  late fm.MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = fm.MapController();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasCoordinates = widget.product.latitude != null && widget.product.longitude != null;

    if (!hasCoordinates) {
      return _buildNoLocationCard();
    }

    final sellerLocation = LatLng(widget.product.latitude!, widget.product.longitude!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          child: Text(
            'Seller Location',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.padding),
        Container(
          height: 250,
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
            child: fm.FlutterMap(
              mapController: mapController,
              options: fm.MapOptions(
                initialCenter: sellerLocation,
                initialZoom: 14.0,
                maxZoom: 18.0,
                minZoom: 4.0,
                interactionOptions: const fm.InteractionOptions(
                  flags: fm.InteractiveFlag.all,
                ),
              ),
              children: [
                fm.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mobilepak.app',
                ),
                fm.MarkerLayer(
                  markers: [
                    fm.Marker(
                      point: sellerLocation,
                      width: 80,
                      height: 80,
                      child: _buildSellerPin(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppDimensions.padding),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
          child: Container(
            padding: EdgeInsets.all(AppDimensions.padding),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.accent,
                  size: 20,
                ),
                SizedBox(width: AppDimensions.gapMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.location,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${widget.product.distance} away',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerPin() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.accent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: AppColors.accent,
              ),
              const SizedBox(width: 4),
              Text(
                'Seller',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
        CustomPaint(
          size: const Size(8, 4),
          painter: _TrianglePainter(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildNoLocationCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.padding),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.padding),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_off,
              color: AppColors.secondary,
              size: 20,
            ),
            SizedBox(width: AppDimensions.gapMedium),
            Expanded(
              child: Text(
                'Seller location not available',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
