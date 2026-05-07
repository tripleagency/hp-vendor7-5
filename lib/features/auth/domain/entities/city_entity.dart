import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final int id;
  final String countryId;
  final String nameEn;
  final String nameAr;
  final String createdAt;
  final String updatedAt;

  const CityEntity({
    required this.id,
    required this.countryId,
    required this.nameEn,
    required this.nameAr,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    countryId,
    nameEn,
    nameAr,
    createdAt,
    updatedAt,
  ];
}
