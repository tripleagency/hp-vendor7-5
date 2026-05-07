import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RegisterUseCase extends UseCase<RegisterResponseEntity, RegisterParams> {
  final IAuthRepository repository;

  RegisterUseCase({required this.repository});

  @override
  Future<Either<Failure, RegisterResponseEntity>> call(
    RegisterParams params,
  ) async {
    return await repository.register(params);
  }
}
