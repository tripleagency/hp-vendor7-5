import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/general/domain/repositories/i_general_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final IGeneralRepository _repository;

  GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await _repository.getCategories();
  }
}
