class LoginParams {
  final String phone;
  final String password;

  LoginParams({required this.phone, required this.password});

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'password': password};
  }
}
