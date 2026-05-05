import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static const LatLng kPakistanCenter = LatLng(30.3753, 69.3451);
  static const LatLng kIslamabadCenter = LatLng(33.6844, 73.0479);

  /// Get current user position. On web, triggers browser geolocation prompt.
  /// Returns null if permission denied or unavailable.
  static Future<LatLng?> getCurrentPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
      return LatLng(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }

  /// Check if location services are enabled without requesting permission.
  static Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (_) {
      return false;
    }
  }

  /// Calculate distance between two LatLng points in kilometers (Haversine formula).
  static double distanceKm(LatLng from, LatLng to) {
    const R = 6371.0; // Earth's radius in km
    final lat1 = _toRad(from.latitude);
    final lat2 = _toRad(to.latitude);
    final dLat = _toRad(to.latitude - from.latitude);
    final dLng = _toRad(to.longitude - from.longitude);

    final a = _sin2(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) * _sin2(dLng / 2);
    final c = 2 * _atan2(_sqrt(a), _sqrt(1 - a));
    return R * c;
  }

  static double _toRad(double deg) => deg * math.pi / 180.0;
  static double _sin2(double x) => math.sin(x) * math.sin(x);
  static double _sqrt(double x) => math.sqrt(x);
  static double _atan2(double y, double x) => math.atan2(y, x);
}
