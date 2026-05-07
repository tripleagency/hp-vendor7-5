import 'package:equatable/equatable.dart';

class AppUserEntity extends Equatable {
  final int id;
  final String? cityId;
  final String? areaId;
  final String name;
  final String email;
  final String phone;
  final String? gender;
  final String? photo;
  final String? dob;
  final String? deliveryAddresses;
  final String? location;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const AppUserEntity({
    required this.id,
    this.cityId,
    this.areaId,
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
    this.photo,
    this.dob,
    this.deliveryAddresses,
    this.location,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        cityId,
        areaId,
        name,
        email,
        phone,
        gender,
        photo,
        dob,
        deliveryAddresses,
        location,
        isActive,
        createdAt,
        updatedAt,
      ];
}
