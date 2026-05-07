import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';

@lazySingleton
class ForgotPasswordUseCase
    implements UseCase<Map<String, dynamic>, ForgotPasswordParams> {
  final IAuthRepository repository;

  ForgotPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ForgotPasswordParams params,
  ) async {
    return await repository.forgotPassword(params);
  }
}
