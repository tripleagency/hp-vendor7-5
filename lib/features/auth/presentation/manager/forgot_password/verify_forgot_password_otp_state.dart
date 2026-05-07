import 'package:equatable/equatable.dart';

abstract class VerifyForgotPasswordOtpState extends Equatable {
  const VerifyForgotPasswordOtpState();

  @override
  List<Object?> get props => [];
}

class VerifyForgotPasswordOtpInitial extends VerifyForgotPasswordOtpState {}

class VerifyForgotPasswordOtpLoading extends VerifyForgotPasswordOtpState {}

class VerifyForgotPasswordOtpSuccess extends VerifyForgotPasswordOtpState {
  final Map<String, dynamic> response;
  const VerifyForgotPasswordOtpSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class VerifyForgotPasswordOtpFailure extends VerifyForgotPasswordOtpState {
  final String message;
  const VerifyForgotPasswordOtpFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
