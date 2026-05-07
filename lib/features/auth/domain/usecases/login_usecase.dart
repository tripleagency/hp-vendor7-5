import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';

@lazySingleton
class LoginUseCase implements UseCase<LoginResponseEntity, LoginParams> {
  final IAuthRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, LoginResponseEntity>> call(LoginParams params) async {
    return await repository.login(params);
  }
}
