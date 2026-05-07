import 'dart:io';
import 'package:dio/dio.dart';

class UpdateProfileParams {
  final String fullName;
  final String email;
  final String phone;
  final String restaurantName;
  final String restaurantInfo;
  final String? countryId;
  final String cityId;
  final String areaId;
  final String deliveryAddress;
  final String location;
  final double? lat;
  final double? lng;
  final String? deliveryPrice;
  final String? deliveryTime;
  final File? mainPhoto;
  final File? idFront;
  final File? idBack;
  final List<File?> kitchenPhotos;
  final Map<String, dynamic>? workingTime;

  const UpdateProfileParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.restaurantName,
    required this.restaurantInfo,
    this.countryId,
    required this.cityId,
    required this.areaId,
    required this.deliveryAddress,
    required this.location,
    this.lat,
    this.lng,
    this.deliveryPrice,
    this.deliveryTime,
    this.mainPhoto,
    this.idFront,
    this.idBack,
    this.kitchenPhotos = const [],
    this.workingTime,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'restaurant_name': restaurantName,
      'restaurant_info': restaurantInfo,
      if (countryId != null && countryId!.isNotEmpty) 'country_id': countryId,
      'city_id': cityId,
      'area_id': areaId,
      'delivery_address': deliveryAddress,
      'location': location,
      if (lat != null) 'lat': lat.toString(),
      if (lng != null) 'lng': lng.toString(),
      if (deliveryPrice != null && deliveryPrice!.isNotEmpty)
        'delivery_price': deliveryPrice,
      if (deliveryTime != null && deliveryTime!.isNotEmpty)
        'delivery_time': deliveryTime,
    };

    if (mainPhoto != null) {
      data['main_photo'] = await MultipartFile.fromFile(mainPhoto!.path);
    }
    if (idFront != null) {
      data['id_front'] = await MultipartFile.fromFile(idFront!.path);
    }
    if (idBack != null) {
      data['id_back'] = await MultipartFile.fromFile(idBack!.path);
    }

    for (int i = 0; i < kitchenPhotos.length; i++) {
      if (kitchenPhotos[i] != null) {
        data['kitchen_photo_${i + 1}'] = await MultipartFile.fromFile(
          kitchenPhotos[i]!.path,
        );
      }
    }

    if (workingTime != null) {
      data['working_time[day]'] = workingTime!['day'];
      data['working_time[from]'] = workingTime!['from'];
      data['working_time[to]'] = workingTime!['to'];
    }

    return FormData.fromMap(data);
  }
}
