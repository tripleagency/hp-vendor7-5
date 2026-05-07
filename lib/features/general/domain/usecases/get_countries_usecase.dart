import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';
import 'package:home_plate_vendor/features/general/domain/repositories/i_general_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCountriesUseCase implements UseCase<List<CountryEntity>, NoParams> {
  final IGeneralRepository _repository;

  GetCountriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CountryEntity>>> call(NoParams params) {
    return _repository.getCountries();
  }
}
