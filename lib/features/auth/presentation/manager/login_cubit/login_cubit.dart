import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/login_response_entity.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/login_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/login_usecase.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(const LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    if (state is LoginLoading) return; // ✋ guard — prevent duplicate calls

    emit(const LoginLoading());

    final params = LoginParams(phone: phone, password: password);
    final result = await _loginUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(LoginFailure(message: failure.message)),
      (response) => emit(LoginSuccess(response: response)),
    );
  }
}
