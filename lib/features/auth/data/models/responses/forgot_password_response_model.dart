class ForgotPasswordResponseModel {
  final String message;
  final int expiresInMinutes;

  ForgotPasswordResponseModel({
    required this.message,
    required this.expiresInMinutes,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      message: json['message'] ?? '',
      expiresInMinutes: json['expires_in_minutes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'expires_in_minutes': expiresInMinutes};
  }
}
