import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';
import 'package:home_plate_vendor/features/general/domain/repositories/i_general_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAreasUseCase implements UseCase<List<AreaEntity>, NoParams> {
  final IGeneralRepository _repository;

  GetAreasUseCase(this._repository);

  @override
  Future<Either<Failure, List<AreaEntity>>> call(NoParams params) {
    return _repository.getAreas();
  }
}
