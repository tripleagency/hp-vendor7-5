import 'dart:math' as Math;
import 'package:geolocator/geolocator.dart';
import 'package:home_plate_vendor/core/services/location_service.dart';

/// فئة مساعدة لعمليات الموقع الشائعة
/// Helper class for common location operations
class LocationHelper {
  /// التحقق من إمكانية الوصول للموقع
  /// Check if location is accessible
  static Future<bool> isLocationAccessible() async {
    try {
      bool serviceEnabled = await LocationService.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      final permission = await LocationService.checkAndRequestPermission();
      return permission != LocationPermission.denied && 
             permission != LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }

  /// محاولة الحصول على الموقع بدون رفع Exception
  /// Safely get location without throwing exceptions
  static Future<LocationData?> getLocationSafely() async {
    try {
      return await LocationService.getCurrentLocationAsAddress();
    } catch (e) {
      print('Location Error: $e');
      return null;
    }
  }

  /// التحقق من مسافة بين نقطتين بالكيلومترات
  /// Calculate distance between two coordinates in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);
    final a = (Math.sin(dLat / 2) * Math.sin(dLat / 2)) +
        (Math.cos(_degreesToRadians(lat1)) *
            Math.cos(_degreesToRadians(lat2)) *
            Math.sin(dLon / 2) *
            Math.sin(dLon / 2));
    final c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// تحويل الدرجات لراديان
  static double _degreesToRadians(double degrees) {
    return degrees * (3.141592653589793 / 180.0);
  }

  /// إنشاء رابط Google Maps للموقع
  /// Create Google Maps link for location
  static String createGoogleMapsLink(double latitude, double longitude) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  /// فحص ما إذا كان الموقع ضمن نطاق معين
  /// Check if location is within a certain radius
  static bool isWithinRadius(
    double userLat,
    double userLon,
    double centerLat,
    double centerLon,
    double radiusKm,
  ) {
    final distance = calculateDistance(userLat, userLon, centerLat, centerLon);
    return distance <= radiusKm;
  }
}
