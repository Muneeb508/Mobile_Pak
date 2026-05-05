import 'package:latlong2/latlong.dart';
import '../data/models/product_model.dart';

class MapCluster {
  final List<Product> products;
  final LatLng center;

  const MapCluster({
    required this.products,
    required this.center,
  });

  Product get representative => products.first;
  bool get isSingle => products.length == 1;
  int get count => products.length;

  int get minPrice => products.map((p) => p.priceValue).reduce((a, b) => a < b ? a : b);
  int get maxPrice => products.map((p) => p.priceValue).reduce((a, b) => a > b ? a : b);

  String get priceLabel {
    if (isSingle) {
      return representative.formattedPrice;
    }
    return 'Rs ${_formatK(minPrice)}–${_formatK(maxPrice)}';
  }

  static String _formatK(int price) {
    if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(1)}L';
    }
    return '${(price / 1000).toStringAsFixed(0)}K';
  }
}

class MapClusterService {
  /// Grid-based spatial clustering. Threshold shrinks as user zooms in.
  static List<MapCluster> cluster(List<Product> products, double zoom) {
    final withCoords = products
        .where((p) => p.latitude != null && p.longitude != null)
        .toList();

    if (withCoords.isEmpty) return [];

    final threshold = _thresholdForZoom(zoom);
    final List<MapCluster> result = [];
    final Set<int> assigned = {};

    for (int i = 0; i < withCoords.length; i++) {
      if (assigned.contains(i)) continue;

      final group = <Product>[withCoords[i]];
      assigned.add(i);

      for (int j = i + 1; j < withCoords.length; j++) {
        if (assigned.contains(j)) continue;

        final dLat = (withCoords[i].latitude! - withCoords[j].latitude!).abs();
        final dLng = (withCoords[i].longitude! - withCoords[j].longitude!).abs();

        if (dLat < threshold && dLng < threshold) {
          group.add(withCoords[j]);
          assigned.add(j);
        }
      }

      final avgLat = group.map((p) => p.latitude!).reduce((a, b) => a + b) / group.length;
      final avgLng = group.map((p) => p.longitude!).reduce((a, b) => a + b) / group.length;

      result.add(MapCluster(
        products: group,
        center: LatLng(avgLat, avgLng),
      ));
    }

    return result;
  }

  /// Threshold in degrees. Shrinks as zoom level increases.
  static double _thresholdForZoom(double zoom) {
    if (zoom >= 12) return 0.01;
    if (zoom >= 10) return 0.05;
    if (zoom >= 8) return 0.2;
    if (zoom >= 6) return 1.0;
    return 3.0;
  }
}
