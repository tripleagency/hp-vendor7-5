import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_registration_params.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/verify_registration_usecase.dart';
import 'verify_registration_state.dart';

import 'package:injectable/injectable.dart';

@injectable
class VerifyRegistrationCubit extends Cubit<VerifyRegistrationState> {
  final VerifyRegistrationUseCase _verifyRegistrationUseCase;

  VerifyRegistrationCubit({
    required VerifyRegistrationUseCase verifyRegistrationUseCase,
  }) : _verifyRegistrationUseCase = verifyRegistrationUseCase,
       super(const VerifyRegistrationInitial());

  Future<void> verifyRegistration({
    required String phone,
    required String code,
  }) async {
    if (state is VerifyRegistrationLoading) return; // ✋ guard

    emit(const VerifyRegistrationLoading());

    final params = VerifyRegistrationParams(phone: phone, code: code);
    final result = await _verifyRegistrationUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(VerifyRegistrationFailure(message: failure.message)),
      (response) => emit(VerifyRegistrationSuccess(response: response)),
    );
  }
}
