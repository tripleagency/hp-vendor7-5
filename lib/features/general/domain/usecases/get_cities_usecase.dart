import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';
import 'package:home_plate_vendor/features/general/domain/repositories/i_general_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCitiesUseCase implements UseCase<List<CityEntity>, NoParams> {
  final IGeneralRepository _repository;

  GetCitiesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CityEntity>>> call(NoParams params) {
    return _repository.getCities();
  }
}
