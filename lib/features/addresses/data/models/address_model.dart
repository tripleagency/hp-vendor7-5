import 'package:home_plate_vendor/features/addresses/domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.title,
    required super.addressLine1,
    super.addressLine2,
    required super.townCity,
    required super.regionState,
    required super.lat,
    required super.lng,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];
    double parseLat() {
      if (loc is Map) {
        final v = loc['lat'] ?? loc['latitude'];
        if (v is num) return v.toDouble();
        return double.tryParse(v?.toString() ?? '') ?? 0.0;
      }
      final v = json['lat'] ?? json['latitude'];
      if (v is num) return v.toDouble();
      return double.tryParse(v?.toString() ?? '') ?? 0.0;
    }

    double parseLng() {
      if (loc is Map) {
        final v = loc['long'] ?? loc['lng'] ?? loc['longitude'];
        if (v is num) return v.toDouble();
        return double.tryParse(v?.toString() ?? '') ?? 0.0;
      }
      final v = json['lng'] ?? json['longitude'];
      if (v is num) return v.toDouble();
      return double.tryParse(v?.toString() ?? '') ?? 0.0;
    }

    return AddressModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      addressLine1: json['address_line_1']?.toString() ?? '',
      addressLine2: json['address_line_2']?.toString(),
      townCity: json['town_city']?.toString() ?? '',
      regionState: json['region_state']?.toString() ?? '',
      lat: parseLat(),
      lng: parseLng(),
    );
  }
}
