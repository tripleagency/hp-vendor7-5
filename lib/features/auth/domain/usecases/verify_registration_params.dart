class VerifyRegistrationParams {
  final String phone;
  final String code;

  VerifyRegistrationParams({required this.phone, required this.code});

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'otp': code};
  }
}
