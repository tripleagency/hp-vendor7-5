import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/delivery_entity.dart';

class DeliveryModel extends DeliveryEntity {
  const DeliveryModel({
    required super.id,
    required super.firstName,
    required super.email,
    required super.phone,
    super.photo,
    super.cityId,
    super.areaId,
    super.driversLicense,
    super.nationalId,
    super.vehiclePhoto,
    super.vehicleType,
    super.vehicleLicense,
    super.status,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      firstName: json['first_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      photo: json['photo']?.toString(),
      cityId: json['city_id']?.toString(),
      areaId: json['area_id']?.toString(),
      driversLicense: json['drivers_license']?.toString(),
      nationalId: json['national_id']?.toString(),
      vehiclePhoto: json['vehicle_photo']?.toString(),
      vehicleType: json['vehicle_type']?.toString(),
      vehicleLicense: json['vehicle_license']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
