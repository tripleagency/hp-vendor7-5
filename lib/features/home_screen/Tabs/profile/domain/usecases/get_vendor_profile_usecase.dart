import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/repositories/profile_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetVendorProfileUseCase implements UseCase<VendorEntity, int> {
  final ProfileRepository _repository;

  GetVendorProfileUseCase(this._repository);

  @override
  Future<Either<Failure, VendorEntity>> call(int vendorId) async {
    return await _repository.getVendorProfile(vendorId);
  }
}
