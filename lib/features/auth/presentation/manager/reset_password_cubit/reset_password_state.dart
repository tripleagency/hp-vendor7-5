import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;

  const ResetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;
  final Map<String, dynamic>? errors;

  const ResetPasswordFailure({required this.message, this.errors});

  @override
  List<Object?> get props => [message, errors];
}
