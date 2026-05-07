import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// خدمة الموقع الجغرافي - Location Service
/// تتعامل مع الحصول على موقع الجهاز وتحويله لعنوان نصي
class LocationService {
  /// التحقق من تفعيل خدمات الموقع
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// التحقق من الأذونات وطلبها
  static Future<LocationPermission> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission;
  }

  /// الحصول على الموقع الحالي للجهاز
  /// Returns: Position object تحتوي على latitude و longitude
  static Future<Position> getCurrentLocation() async {
    try {
      // التحقق من تفعيل خدمات الموقع
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('LOCATION_SERVICE_DISABLED');
      }

      // التحقق من الأذونات
      LocationPermission permission = await checkAndRequestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw LocationException('LOCATION_PERMISSION_DENIED');
      }

      // الحصول على الموقع مع دقة عالية
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 30),
      );

      return position;
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('LOCATION_FETCH_FAILED');
    }
  }

  /// تحويل الموقع الجغرافي (latitude, longitude) إلى عنوان نصي
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isEmpty) {
        return 'UNABLE_TO_DETERMINE_ADDRESS';
      }

      Placemark place = placemarks.first;

      // بناء العنوان من البيانات المتاحة
      String address = '';
      
      if (place.street != null && place.street!.isNotEmpty) {
        address += place.street!;
      }
      
      if (place.subLocality != null && place.subLocality!.isNotEmpty) {
        address += '${address.isNotEmpty ? ', ' : ''}${place.subLocality}';
      }
      
      if (place.locality != null && place.locality!.isNotEmpty) {
        address += '${address.isNotEmpty ? ', ' : ''}${place.locality}';
      }
      
      if (place.administrativeArea != null &&
          place.administrativeArea!.isNotEmpty) {
        address += '${address.isNotEmpty ? ', ' : ''}${place.administrativeArea}';
      }

      return address.isNotEmpty ? address : 'ADDRESS_UNDEFINED';
    } catch (e) {
      throw LocationException('ADDRESS_CONVERSION_FAILED');
    }
  }

  /// الحصول على الموقع الحالي وتحويله لعنوان مباشرة
  static Future<LocationData> getCurrentLocationAsAddress() async {
    try {
      Position position = await getCurrentLocation();
      String address =
          await getAddressFromCoordinates(position.latitude, position.longitude);

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// نموذج بيانات الموقع
class LocationData {
  final double latitude;
  final double longitude;
  final String address;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  /// تحويل البيانات لـ Map للتخزين
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  /// إنشاء LocationData من Map
  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      address: map['address'] as String,
    );
  }
}

/// Custom Exception للأخطاء المتعلقة بالموقع
class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => message;
}
