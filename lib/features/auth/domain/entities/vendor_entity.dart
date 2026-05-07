import 'package:equatable/equatable.dart';
import 'city_entity.dart';
import 'area_entity.dart';

class VendorEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String idFront;
  final String idBack;
  final String restaurantInfo;
  final String mainPhoto;
  final String restaurantName;
  final String cityId;
  final String areaId;
  final String deliveryAddress;
  final String location;
  final List<String> kitchenPhotos;
  final Map<String, dynamic> workingTime;
  final bool isActive;
  final String status;
  final String? rejectionReason;
  final CityEntity? city;
  final AreaEntity? area;

  const VendorEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.idFront,
    required this.idBack,
    required this.restaurantInfo,
    required this.mainPhoto,
    required this.restaurantName,
    required this.cityId,
    required this.areaId,
    required this.deliveryAddress,
    required this.location,
    required this.kitchenPhotos,
    required this.workingTime,
    required this.isActive,
    required this.status,
    this.rejectionReason,
    this.city,
    this.area,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    isActive,
    status,
    city,
    area,
  ];
}
