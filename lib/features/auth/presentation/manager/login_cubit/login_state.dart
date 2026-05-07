part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginResponseEntity response;
  const LoginSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends LoginState {
  final String message;
  const LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
