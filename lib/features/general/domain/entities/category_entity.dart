import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String nameEn;
  final String nameAr;
  final String photo;

  const CategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.photo,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr, photo];
}
