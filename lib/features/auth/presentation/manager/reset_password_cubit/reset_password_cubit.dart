import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/reset_password_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:injectable/injectable.dart';
import 'reset_password_state.dart';

@injectable
class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit({required ResetPasswordUseCase resetPasswordUseCase})
    : _resetPasswordUseCase = resetPasswordUseCase,
      super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    if (state is ResetPasswordLoading) return; // ✋ guard
    if (isClosed) return;

    emit(ResetPasswordLoading());

    final params = ResetPasswordParams(
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    final result = await _resetPasswordUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) {
        Map<String, dynamic>? errors;
        if (failure is ValidationFailure) {
          errors = failure.errors;
        }
        emit(ResetPasswordFailure(message: failure.message, errors: errors));
      },
      (response) => emit(
        ResetPasswordSuccess(
          message: response['message'] ?? 'Password reset successfully.',
        ),
      ),
    );
  }
}
