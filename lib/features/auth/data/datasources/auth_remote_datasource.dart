import 'package:home_plate_vendor/features/auth/domain/usecases/forgot_password_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/reset_password_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_params.dart';
import 'package:injectable/injectable.dart';
import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/features/auth/data/models/requests/register_request_model.dart';
import 'package:home_plate_vendor/features/auth/data/models/responses/register_response_model.dart';
import 'package:home_plate_vendor/features/auth/data/models/responses/verify_registration_response_model.dart';
import 'package:home_plate_vendor/features/auth/data/models/responses/login_response_model.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterParams params);
  Future<VerifyRegistrationResponseModel> verifyRegistration(
    VerifyRegistrationParams params,
  );
  Future<LoginResponseModel> login(LoginParams params);
  Future<Map<String, dynamic>> forgotPassword(ForgotPasswordParams params);
  Future<Map<String, dynamic>> resetPassword(ResetPasswordParams params);
  Future<Map<String, dynamic>> verifyForgotPasswordOtp(
    VerifyForgotPasswordOtpParams params,
  );
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioConsumer api;

  const AuthRemoteDataSourceImpl({required this.api});

  @override
  Future<RegisterResponseModel> register(RegisterParams params) async {
    final requestModel = RegisterRequestModel(params: params);
    final formData = await requestModel.toFormData();

    final response = await api.postFormData(
      ServerStrings.vendorRegister,
      formData: formData,
    );

    if (response is! Map<String, dynamic>) {
      throw ParseException(message: 'Unexpected response format');
    }

    return RegisterResponseModel.fromJson(response);
  }

  @override
  Future<VerifyRegistrationResponseModel> verifyRegistration(
    VerifyRegistrationParams params,
  ) async {
    final response = await api.post(
      ServerStrings.vendorVerifyOtp,
      body: params.toJson(),
    );

    if (response is! Map<String, dynamic>) {
      throw ParseException(message: 'Unexpected response format');
    }

    return VerifyRegistrationResponseModel.fromJson(response);
  }

  @override
  Future<LoginResponseModel> login(LoginParams params) async {
    final response = await api.post(
      ServerStrings.vendorLogin,
      body: params.toJson(),
    );

    if (response is! Map<String, dynamic>) {
      throw ParseException(message: 'Unexpected response format');
    }

    return LoginResponseModel.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(
    ForgotPasswordParams params,
  ) async {
    final response = await api.post(
      ServerStrings.vendorForgotPassword,
      body: params.toJson(),
    );

    if (response is! Map<String, dynamic>) {
      throw ParseException(message: 'Unexpected response format');
    }

    return response;
  }

  @override
  Future<Map<String, dynamic>> resetPassword(ResetPasswordParams params) async {
    final response = await api.postFormData(
      ServerStrings.vendorResetPassword,
      formData: params.toFormData(),
    );

    if (response is! Map<String, dynamic>) {
      throw ParseException(message: 'Unexpected response format');
    }

    return response;
  }

  @override
  Future<Map<String, dynamic>> verifyForgotPasswordOtp(
    VerifyForgotPasswordOtpParams params,
  ) async {
    final response = await api.post(
      ServerStrings.vendorVerifyForgotPasswordOtp,
      body: params.toJson(),
    );

    if (response is! Map<String, dynamic>) {
      throw ParseException(message: 'Unexpected response format');
    }

    return response;
  }
}
