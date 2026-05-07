import 'package:equatable/equatable.dart';
import 'vendor_entity.dart';

class LoginResponseEntity extends Equatable {
  final String message;
  final String token;
  final VendorEntity vendor;

  const LoginResponseEntity({
    required this.message,
    required this.token,
    required this.vendor,
  });

  @override
  List<Object?> get props => [message, token, vendor];
}
