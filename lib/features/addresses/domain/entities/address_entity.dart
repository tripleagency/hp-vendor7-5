import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final int id;
  final String title;
  final String addressLine1;
  final String? addressLine2;
  final String townCity;
  final String regionState;
  final double lat;
  final double lng;

  const AddressEntity({
    required this.id,
    required this.title,
    required this.addressLine1,
    this.addressLine2,
    required this.townCity,
    required this.regionState,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    addressLine1,
    addressLine2,
    townCity,
    regionState,
    lat,
    lng,
  ];
}
