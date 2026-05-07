import 'package:equatable/equatable.dart';

class AreaEntity extends Equatable {
  final int id;
  final String cityId;
  final String nameEn;
  final String nameAr;
  final String createdAt;
  final String updatedAt;

  const AreaEntity({
    required this.id,
    required this.cityId,
    required this.nameEn,
    required this.nameAr,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, cityId, nameEn, nameAr, createdAt, updatedAt];
}
