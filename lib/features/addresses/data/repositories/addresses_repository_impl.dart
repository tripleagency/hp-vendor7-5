import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/addresses/data/datasources/addresses_remote_data_source.dart';
import 'package:home_plate_vendor/features/addresses/domain/entities/address_entity.dart';
import 'package:home_plate_vendor/features/addresses/domain/repositories/addresses_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource remoteDataSource;

  const AddressesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() {
    return _handle(() => remoteDataSource.getAddresses());
  }

  @override
  Future<Either<Failure, AddressEntity>> createAddress({
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  }) {
    return _handle(
      () => remoteDataSource.createAddress(
        title: title,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        townCity: townCity,
        regionState: regionState,
        lat: lat,
        lng: lng,
      ),
    );
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress({
    required int id,
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  }) {
    return _handle(
      () => remoteDataSource.updateAddress(
        id: id,
        title: title,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        townCity: townCity,
        regionState: regionState,
        lat: lat,
        lng: lng,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteAddress(int id) {
    return _handle(() => remoteDataSource.deleteAddress(id));
  }

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() call) async {
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
