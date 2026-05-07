import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/data/datasources/profile_remote_data_source.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/repositories/profile_repository.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_params.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, VendorEntity>> getVendorProfile(int vendorId) async {
    return _handleRepoCall(() => _remoteDataSource.getVendorProfile(vendorId));
  }

  @override
  Future<Either<Failure, VendorEntity>> updateVendorProfile(
    int vendorId,
    UpdateProfileParams params,
  ) async {
    return _handleRepoCall(
      () => _remoteDataSource.updateVendorProfile(vendorId, params),
    );
  }

  Future<Either<Failure, T>> _handleRepoCall<T>(
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
