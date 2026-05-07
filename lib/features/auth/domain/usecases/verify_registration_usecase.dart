import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';

@lazySingleton
class VerifyRegistrationUseCase
    extends
        UseCase<VerifyRegistrationResponseEntity, VerifyRegistrationParams> {
  final IAuthRepository repository;

  VerifyRegistrationUseCase({required this.repository});

  @override
  Future<Either<Failure, VerifyRegistrationResponseEntity>> call(
    VerifyRegistrationParams params,
  ) {
    return repository.verifyRegistration(params);
  }
}
