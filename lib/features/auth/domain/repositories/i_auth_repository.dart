import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/register_response_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/verify_registration_response_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/login_response_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/register_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_registration_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/login_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/forgot_password_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/reset_password_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_params.dart';

export 'package:home_plate_vendor/features/auth/domain/entities/working_time_entity.dart';
export 'package:home_plate_vendor/features/auth/domain/entities/register_response_entity.dart';
export 'package:home_plate_vendor/features/auth/domain/entities/verify_registration_response_entity.dart';
export 'package:home_plate_vendor/features/auth/domain/entities/login_response_entity.dart';
export 'package:home_plate_vendor/features/auth/domain/usecases/register_params.dart';
export 'package:home_plate_vendor/features/auth/domain/usecases/verify_registration_params.dart';
export 'package:home_plate_vendor/features/auth/domain/usecases/login_params.dart';
export 'package:home_plate_vendor/features/auth/domain/usecases/forgot_password_params.dart';
export 'package:home_plate_vendor/features/auth/domain/usecases/reset_password_params.dart';
export 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_params.dart';

abstract class IAuthRepository {
  Future<Either<Failure, RegisterResponseEntity>> register(
    RegisterParams params,
  );

  Future<Either<Failure, VerifyRegistrationResponseEntity>> verifyRegistration(
    VerifyRegistrationParams params,
  );

  Future<Either<Failure, LoginResponseEntity>> login(LoginParams params);

  Future<Either<Failure, Map<String, dynamic>>> forgotPassword(
    ForgotPasswordParams params,
  );

  Future<Either<Failure, Map<String, dynamic>>> resetPassword(
    ResetPasswordParams params,
  );

  Future<Either<Failure, Map<String, dynamic>>> verifyForgotPasswordOtp(
    VerifyForgotPasswordOtpParams params,
  );
}
