import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_forgot_password_otp_usecase.dart';
import 'package:home_plate_vendor/features/auth/presentation/manager/forgot_password/verify_forgot_password_otp_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class VerifyForgotPasswordOtpCubit extends Cubit<VerifyForgotPasswordOtpState> {
  final VerifyForgotPasswordOtpUseCase verifyForgotPasswordOtpUseCase;

  VerifyForgotPasswordOtpCubit({required this.verifyForgotPasswordOtpUseCase})
    : super(VerifyForgotPasswordOtpInitial());

  Future<void> verifyForgotPasswordOtp(String phone, String otp) async {
    emit(VerifyForgotPasswordOtpLoading());

    final params = VerifyForgotPasswordOtpParams(phone: phone, otp: otp);
    final result = await verifyForgotPasswordOtpUseCase(params);

    result.fold(
      (failure) =>
          emit(VerifyForgotPasswordOtpFailure(message: failure.message)),
      (response) => emit(VerifyForgotPasswordOtpSuccess(response: response)),
    );
  }
}
