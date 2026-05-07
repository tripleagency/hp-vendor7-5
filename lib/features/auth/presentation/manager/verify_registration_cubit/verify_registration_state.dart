import 'package:equatable/equatable.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/verify_registration_response_entity.dart';

abstract class VerifyRegistrationState extends Equatable {
  const VerifyRegistrationState();

  @override
  List<Object?> get props => [];
}

class VerifyRegistrationInitial extends VerifyRegistrationState {
  const VerifyRegistrationInitial();
}

class VerifyRegistrationLoading extends VerifyRegistrationState {
  const VerifyRegistrationLoading();
}

class VerifyRegistrationSuccess extends VerifyRegistrationState {
  final VerifyRegistrationResponseEntity response;
  const VerifyRegistrationSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class VerifyRegistrationFailure extends VerifyRegistrationState {
  final String message;
  const VerifyRegistrationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
