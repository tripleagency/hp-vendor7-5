import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';

class AreaModel extends AreaEntity {
  const AreaModel({
    required super.id,
    required super.cityId,
    required super.nameEn,
    required super.nameAr,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) {
    return AreaModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      cityId: json['city_id']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
