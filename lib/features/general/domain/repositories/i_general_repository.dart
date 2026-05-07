import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/area_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/city_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/country_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';

abstract class IGeneralRepository {
  Future<Either<Failure, List<CountryEntity>>> getCountries();
  Future<Either<Failure, List<CityEntity>>> getCities();
  Future<Either<Failure, List<AreaEntity>>> getAreas();
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
