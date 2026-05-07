import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'city_model.dart';
import 'area_model.dart';

class VendorModel extends VendorEntity {
  const VendorModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.idFront,
    required super.idBack,
    required super.restaurantInfo,
    required super.mainPhoto,
    required super.restaurantName,
    required super.cityId,
    required super.areaId,
    required super.deliveryAddress,
    required super.location,
    required super.kitchenPhotos,
    required super.workingTime,
    required super.isActive,
    required super.status,
    super.rejectionReason,
    super.city,
    super.area,
  });

  factory VendorModel.empty() {
    return const VendorModel(
      id: 0,
      fullName: '',
      email: '',
      phone: '',
      idFront: '',
      idBack: '',
      restaurantInfo: '',
      mainPhoto: '',
      restaurantName: '',
      cityId: '',
      areaId: '',
      deliveryAddress: '',
      location: '',
      kitchenPhotos: [],
      workingTime: {},
      isActive: false,
      status: '',
      city: null,
      area: null,
    );
  }

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    List<String> photos = [];
    if (json['kitchen_photo_1'] != null) {
      photos.add(json['kitchen_photo_1'].toString());
    }
    if (json['kitchen_photo_2'] != null) {
      photos.add(json['kitchen_photo_2'].toString());
    }
    if (json['kitchen_photo_3'] != null) {
      photos.add(json['kitchen_photo_3'].toString());
    }

    return VendorModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fullName: json['full_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      idFront: json['id_front']?.toString() ?? '',
      idBack: json['id_back']?.toString() ?? '',
      restaurantInfo: json['restaurant_info']?.toString() ?? '',
      mainPhoto: json['main_photo']?.toString() ?? '',
      restaurantName: json['restaurant_name']?.toString() ?? '',
      cityId: json['city_id']?.toString() ?? '',
      areaId: json['area_id']?.toString() ?? '',
      deliveryAddress: json['delivery_address']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      kitchenPhotos: photos,
      workingTime: json['working_time'] is Map
          ? Map<String, dynamic>.from(json['working_time'] as Map)
          : {},
      isActive: json['is_active'] == true,
      status: json['status']?.toString() ?? '',
      rejectionReason: json['rejection_reason']?.toString(),
      city: json['city'] != null
          ? CityModel.fromJson(Map<String, dynamic>.from(json['city'] as Map))
          : null,
      area: json['area'] != null
          ? AreaModel.fromJson(Map<String, dynamic>.from(json['area'] as Map))
          : null,
    );
  }
}
