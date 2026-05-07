import 'package:home_plate_vendor/features/auth/domain/entities/register_response_entity.dart';

/// Parses the JSON response from /api/vendor/auth/register
class RegisterResponseModel extends RegisterResponseEntity {
  const RegisterResponseModel({
    required super.message,
    required super.expiresInMinutes,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      message: json['message'] as String? ?? '',
      expiresInMinutes: json['expires_in_minutes'] as int? ?? 10,
    );
  }
}
