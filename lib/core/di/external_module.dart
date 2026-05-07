import 'package:dio/dio.dart';
import 'package:home_plate_vendor/core/api/api_interceptors.dart';
import 'package:home_plate_vendor/core/config/app_config.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';

@module
abstract class ExternalModule {
  @preResolve
  @lazySingleton
  Future<SharedPreferences> get sharedPreferences =>
      SharedPreferences.getInstance();

  @lazySingleton
  InternetConnectionChecker get connectionChecker =>
      InternetConnectionChecker.createInstance();

  @lazySingleton
  Dio dio(CacheHelper cacheHelper) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(ApiInterceptor());
    dio.interceptors.add(
      AuthInterceptor(
        getToken: () async {
          final token = cacheHelper.getData(key: AppConstants.accessTokenKey);
          return token?.toString();
        },
      ),
    );

    if (AppConfig.enableLogging) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }
}
