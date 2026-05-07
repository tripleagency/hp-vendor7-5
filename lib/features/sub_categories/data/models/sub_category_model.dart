import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    required super.id,
    required super.nameEn,
    required super.nameAr,
    required super.categoryId,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      nameEn: json['name_en']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      categoryId: int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
    );
  }
}
