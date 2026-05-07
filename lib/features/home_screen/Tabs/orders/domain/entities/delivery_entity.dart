import 'package:equatable/equatable.dart';

class DeliveryEntity extends Equatable {
  final int id;
  final String firstName;
  final String email;
  final String phone;
  final String? photo;
  final String? cityId;
  final String? areaId;
  final String? driversLicense;
  final String? nationalId;
  final String? vehiclePhoto;
  final String? vehicleType;
  final String? vehicleLicense;
  final String status;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const DeliveryEntity({
    required this.id,
    required this.firstName,
    required this.email,
    required this.phone,
    this.photo,
    this.cityId,
    this.areaId,
    this.driversLicense,
    this.nationalId,
    this.vehiclePhoto,
    this.vehicleType,
    this.vehicleLicense,
    this.status = 'pending',
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Display name for the delivery person
  String get displayName => firstName;

  @override
  List<Object?> get props => [
        id,
        firstName,
        email,
        phone,
        photo,
        cityId,
        areaId,
        driversLicense,
        nationalId,
        vehiclePhoto,
        vehicleType,
        vehicleLicense,
        status,
        isActive,
        createdAt,
        updatedAt,
      ];
}
