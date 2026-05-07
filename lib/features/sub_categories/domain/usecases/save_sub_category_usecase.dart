import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/repositories/sub_categories_repository.dart';
import 'package:injectable/injectable.dart';

class SaveSubCategoryParams {
  final int? id; // null = create, present = update
  final String nameEn;
  final String nameAr;
  final int categoryId;

  const SaveSubCategoryParams({
    this.id,
    required this.nameEn,
    required this.nameAr,
    required this.categoryId,
  });
}

@lazySingleton
class SaveSubCategoryUseCase
    extends UseCase<SubCategoryEntity, SaveSubCategoryParams> {
  final SubCategoriesRepository repository;

  SaveSubCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, SubCategoryEntity>> call(
    SaveSubCategoryParams params,
  ) {
    if (params.id == null) {
      return repository.createSubCategory(
        nameEn: params.nameEn,
        nameAr: params.nameAr,
        categoryId: params.categoryId,
      );
    }
    return repository.updateSubCategory(
      id: params.id!,
      nameEn: params.nameEn,
      nameAr: params.nameAr,
      categoryId: params.categoryId,
    );
  }
}

@lazySingleton
class DeleteSubCategoryUseCase extends UseCase<void, int> {
  final SubCategoriesRepository repository;

  DeleteSubCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) {
    return repository.deleteSubCategory(id);
  }
}
