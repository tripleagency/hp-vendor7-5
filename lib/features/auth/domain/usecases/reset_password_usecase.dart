import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';

@lazySingleton
class ResetPasswordUseCase
    implements UseCase<Map<String, dynamic>, ResetPasswordParams> {
  final IAuthRepository repository;

  ResetPasswordUseCase({required this.repository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    ResetPasswordParams params,
  ) async {
    return await repository.resetPassword(params);
  }
}
