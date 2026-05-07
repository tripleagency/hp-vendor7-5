import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';

abstract class SubCategoriesRepository {
  Future<Either<Failure, List<SubCategoryEntity>>> getSubCategories();

  Future<Either<Failure, SubCategoryEntity>> createSubCategory({
    required String nameEn,
    required String nameAr,
    required int categoryId,
  });

  Future<Either<Failure, SubCategoryEntity>> updateSubCategory({
    required int id,
    required String nameEn,
    required String nameAr,
    required int categoryId,
  });

  Future<Either<Failure, void>> deleteSubCategory(int id);
}
