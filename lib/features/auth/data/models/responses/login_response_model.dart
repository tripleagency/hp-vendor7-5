import 'package:home_plate_vendor/features/auth/data/models/responses/vendor_model.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/login_response_entity.dart';

class LoginResponseModel extends LoginResponseEntity {
  const LoginResponseModel({
    required super.message,
    required super.token,
    required super.vendor,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      vendor: json['vendor'] != null
          ? VendorModel.fromJson(
              Map<String, dynamic>.from(json['vendor'] as Map),
            )
          : VendorModel.empty(),
    );
  }
}
