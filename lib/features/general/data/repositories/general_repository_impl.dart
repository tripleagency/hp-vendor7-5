import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';
import 'package:home_plate_vendor/features/general/data/datasources/general_remote_datasource.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/general/domain/repositories/i_general_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IGeneralRepository)
class GeneralRepositoryImpl implements IGeneralRepository {
  final GeneralRemoteDataSource _remoteDataSource;

  GeneralRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    return _execute(() => _remoteDataSource.getCountries());
  }

  @override
  Future<Either<Failure, List<CityEntity>>> getCities() async {
    return _execute(() => _remoteDataSource.getCities());
  }

  @override
  Future<Either<Failure, List<AreaEntity>>> getAreas() async {
    return _execute(() => _remoteDataSource.getAreas());
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    return _execute(() => _remoteDataSource.getCategories());
  }

  /// Generic executor that wraps any data source call in consistent error handling
  Future<Either<Failure, T>> _execute<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
