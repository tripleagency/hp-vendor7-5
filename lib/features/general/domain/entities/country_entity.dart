import 'package:equatable/equatable.dart';

class CountryEntity extends Equatable {
  final int id;
  final String nameEn;
  final String nameAr;
  final String createdAt;
  final String updatedAt;

  const CountryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr];
}
