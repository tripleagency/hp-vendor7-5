import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/repositories/profile_repository.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateProfileUseCase {
  final ProfileRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, VendorEntity>> call(
    int vendorId,
    UpdateProfileParams params,
  ) async {
    return await _repository.updateVendorProfile(vendorId, params);
  }
}
