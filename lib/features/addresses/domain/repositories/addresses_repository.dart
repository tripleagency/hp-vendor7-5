import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/addresses/domain/entities/address_entity.dart';

abstract class AddressesRepository {
  Future<Either<Failure, List<AddressEntity>>> getAddresses();
  Future<Either<Failure, AddressEntity>> createAddress({
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  });
  Future<Either<Failure, AddressEntity>> updateAddress({
    required int id,
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  });
  Future<Either<Failure, void>> deleteAddress(int id);
}
