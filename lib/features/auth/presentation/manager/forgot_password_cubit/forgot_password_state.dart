import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  final int expiresInMinutes;

  const ForgotPasswordSuccess({
    required this.message,
    required this.expiresInMinutes,
  });

  @override
  List<Object?> get props => [message, expiresInMinutes];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;
  final Map<String, dynamic>? errors;

  const ForgotPasswordFailure({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}
