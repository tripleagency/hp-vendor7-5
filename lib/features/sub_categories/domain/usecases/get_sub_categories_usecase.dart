import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/repositories/sub_categories_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetSubCategoriesUseCase
    extends UseCase<List<SubCategoryEntity>, NoParams> {
  final SubCategoriesRepository repository;

  GetSubCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(NoParams params) {
    return repository.getSubCategories();
  }
}
