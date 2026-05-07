import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/features/auth/data/models/responses/area_model.dart';
import 'package:home_plate_vendor/features/auth/data/models/responses/city_model.dart';
import 'package:home_plate_vendor/features/general/data/models/country_model.dart';
import 'package:home_plate_vendor/features/general/data/models/category_model.dart';
import 'package:injectable/injectable.dart';

abstract class GeneralRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<List<CityModel>> getCities();
  Future<List<AreaModel>> getAreas();
  Future<List<CategoryModel>> getCategories();
}

@LazySingleton(as: GeneralRemoteDataSource)
class GeneralRemoteDataSourceImpl implements GeneralRemoteDataSource {
  final DioConsumer _api;

  GeneralRemoteDataSourceImpl(this._api);

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await _api.get(ServerStrings.generalCountries);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((e) => CountryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<List<CityModel>> getCities() async {
    final response = await _api.get(ServerStrings.generalCities);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((e) => CityModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<List<AreaModel>> getAreas() async {
    final response = await _api.get(ServerStrings.generalAreas);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((e) => AreaModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await _api.get(ServerStrings.generalCategories);
    final List<dynamic> data = response['data'] as List<dynamic>;
    return data
        .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
