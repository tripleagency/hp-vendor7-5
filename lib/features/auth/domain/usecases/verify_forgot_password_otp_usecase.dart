import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_params.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class VerifyForgotPasswordOtpUseCase
    implements UseCase<Map<String, dynamic>, VerifyForgotPasswordOtpParams> {
  final IAuthRepository authRepository;

  const VerifyForgotPasswordOtpUseCase({required this.authRepository});

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
    VerifyForgotPasswordOtpParams params,
  ) {
    return authRepository.verifyForgotPasswordOtp(params);
  }
}
