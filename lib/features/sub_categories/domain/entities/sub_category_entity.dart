import 'package:equatable/equatable.dart';

class SubCategoryEntity extends Equatable {
  final int id;
  final String nameEn;
  final String nameAr;
  final int categoryId;

  const SubCategoryEntity({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, nameEn, nameAr, categoryId];
}
