import 'dart:io';
import 'package:home_plate_vendor/features/auth/domain/entities/working_time_entity.dart';

/// Holds all registration form data across both steps
class RegisterParams {
  // --- Step 1 ---
  final String fullName;
  final String phone;
  final String? email;
  final String password;
  final String passwordConfirmation;
  final File idFront;
  final File idBack;

  // --- Step 2 ---
  final String restaurantName;
  final String restaurantInfo;
  final int countryId;
  final int cityId;
  final int areaId;
  final String deliveryAddress;
  final String location;
  final double lat;
  final double lng;
  final String deliveryPrice;
  final String deliveryTime;
  final File mainPhoto;
  final List<File?> kitchenPhotos; // up to 3
  final List<WorkingTimeEntity> workingTimes; // selected days
  final List<int> categoryIds; // restaurant categories

  const RegisterParams({
    // Step 1
    required this.fullName,
    required this.phone,
    this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.idFront,
    required this.idBack,
    // Step 2
    required this.restaurantName,
    required this.restaurantInfo,
    required this.countryId,
    required this.cityId,
    required this.areaId,
    required this.deliveryAddress,
    required this.location,
    required this.lat,
    required this.lng,
    required this.deliveryPrice,
    required this.deliveryTime,
    required this.mainPhoto,
    required this.kitchenPhotos,
    required this.workingTimes,
    this.categoryIds = const [],
  });
}
