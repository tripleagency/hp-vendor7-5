import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_params.dart';

abstract class ProfileRepository {
  Future<Either<Failure, VendorEntity>> getVendorProfile(int vendorId);
  Future<Either<Failure, VendorEntity>> updateVendorProfile(
    int vendorId,
    UpdateProfileParams params,
  );
}
