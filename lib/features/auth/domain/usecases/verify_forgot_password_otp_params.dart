import 'package:equatable/equatable.dart';

class VerifyForgotPasswordOtpParams extends Equatable {
  final String phone;
  final String otp;

  const VerifyForgotPasswordOtpParams({required this.phone, required this.otp});

  Map<String, dynamic> toJson() => {'phone': phone, 'otp': otp};

  @override
  List<Object?> get props => [phone, otp];
}
