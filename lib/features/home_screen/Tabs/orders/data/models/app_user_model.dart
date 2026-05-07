import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/app_user_entity.dart';

class AppUserModel extends AppUserEntity {
  const AppUserModel({
    required super.id,
    super.cityId,
    super.areaId,
    required super.name,
    required super.email,
    required super.phone,
    super.gender,
    super.photo,
    super.dob,
    super.deliveryAddresses,
    super.location,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      cityId: json['city_id']?.toString(),
      areaId: json['area_id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString(),
      photo: json['photo']?.toString(),
      dob: json['dob']?.toString(),
      deliveryAddresses: json['delivery_addresses']?.toString(),
      location: json['location']?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
