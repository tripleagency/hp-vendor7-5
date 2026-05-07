import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:home_plate_vendor/core/cache/cache_helper.dart';
import 'package:home_plate_vendor/core/utils/constants.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final CacheHelper cacheHelper;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheHelper,
  });

  @override
  Future<Either<Failure, RegisterResponseEntity>> register(
    RegisterParams params,
  ) async {
    return _handleAuthCall(() => remoteDataSource.register(params));
  }

  @override
  Future<Either<Failure, VerifyRegistrationResponseEntity>> verifyRegistration(
    VerifyRegistrationParams params,
  ) async {
    return _handleAuthCall(() async {
      final result = await remoteDataSource.verifyRegistration(params);
      await cacheHelper.saveData(
        key: AppConstants.accessTokenKey,
        value: result.token,
      );
      await cacheHelper.saveData(
        key: AppConstants.vendorIdKey,
        value: result.vendor.id,
      );
      return result;
    });
  }

  @override
  Future<Either<Failure, LoginResponseEntity>> login(LoginParams params) async {
    return _handleAuthCall(() async {
      final result = await remoteDataSource.login(params);
      await cacheHelper.saveData(
        key: AppConstants.accessTokenKey,
        value: result.token,
      );
      await cacheHelper.saveData(
        key: AppConstants.vendorIdKey,
        value: result.vendor.id,
      );
      return result;
    });
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(
    ForgotPasswordParams params,
  ) async {
    return _handleAuthCall(() => remoteDataSource.forgotPassword(params));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
    ResetPasswordParams params,
  ) async {
    return _handleAuthCall(() => remoteDataSource.resetPassword(params));
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyForgotPasswordOtp(
    VerifyForgotPasswordOtpParams params,
  ) async {
    return _handleAuthCall(
      () => remoteDataSource.verifyForgotPasswordOtp(params),
    );
  }

  /// Centralized helper to handle authentication API calls and map exceptions to failures.
  Future<Either<Failure, T>> _handleAuthCall<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
