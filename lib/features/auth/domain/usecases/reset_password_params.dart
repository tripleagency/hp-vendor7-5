import 'package:dio/dio.dart';

/// Parameters for Reset Password
class ResetPasswordParams {
  final String phone;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordParams({
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    'phone': phone,
    'password': password,
    'password_confirmation': passwordConfirmation,
  };

  FormData toFormData() => FormData.fromMap(toJson());
}
