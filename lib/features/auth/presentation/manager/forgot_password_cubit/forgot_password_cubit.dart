import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/forgot_password_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:injectable/injectable.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordCubit({required ForgotPasswordUseCase forgotPasswordUseCase})
    : _forgotPasswordUseCase = forgotPasswordUseCase,
      super(ForgotPasswordInitial());

  Future<void> forgotPassword(String phone) async {
    if (state is ForgotPasswordLoading) return; // ✋ guard
    if (isClosed) return;

    emit(ForgotPasswordLoading());

    final params = ForgotPasswordParams(phone: phone);
    final result = await _forgotPasswordUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        Map<String, dynamic>? errors;
        if (failure is ValidationFailure) {
          errors = failure.errors;
        }
        emit(ForgotPasswordFailure(message: failure.message, errors: errors));
      },
      (response) => emit(
        ForgotPasswordSuccess(
          message: response['message'] ?? '',
          expiresInMinutes: response['expires_in_minutes'] ?? 0,
        ),
      ),
    );
  }
}
