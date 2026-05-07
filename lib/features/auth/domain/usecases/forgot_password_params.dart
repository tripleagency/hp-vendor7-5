/// Parameters for Forgot Password
class ForgotPasswordParams {
  final String phone;

  const ForgotPasswordParams({required this.phone});

  Map<String, dynamic> toJson() => {'phone': phone};
}
