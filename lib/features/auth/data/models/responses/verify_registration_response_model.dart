import 'package:home_plate_vendor/features/auth/domain/entities/verify_registration_response_entity.dart';
import 'vendor_model.dart';

class VerifyRegistrationResponseModel extends VerifyRegistrationResponseEntity {
  const VerifyRegistrationResponseModel({
    required super.message,
    required super.token,
    required super.vendor,
  });

  factory VerifyRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyRegistrationResponseModel(
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
