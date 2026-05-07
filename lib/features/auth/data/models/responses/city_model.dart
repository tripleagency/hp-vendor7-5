import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.id,
    required super.countryId,
    required super.nameEn,
    required super.nameAr,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      countryId: json['country_id']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
