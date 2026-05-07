import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:home_plate_vendor/features/auth/domain/usecases/register_usecase.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/register_response_entity.dart';
import 'package:injectable/injectable.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit({required RegisterUseCase registerUseCase})
    : _registerUseCase = registerUseCase,
      super(const RegisterInitial());

  /// Current form data shortcut
  RegisterFormData get formData => state.formData;

  // ---------------------------------------------------------------------------
  // Step 1 — Save user info (no API call)
  // ---------------------------------------------------------------------------
  void saveStep1({
    required String fullName,
    required String phone,
    required String email,
    required String password,
    required File idFront,
    required File idBack,
  }) {
    final updated = state.formData.copyWith(
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
      idFront: idFront,
      idBack: idBack,
    );
    emit(RegisterInitial(formData: updated));
  }

  // ---------------------------------------------------------------------------
  // Step 2 — Save restaurant info (no API call)
  // ---------------------------------------------------------------------------
  void saveStep2({
    required String restaurantName,
    required String restaurantInfo,
    required int countryId,
    required int cityId,
    required int areaId,
    required String deliveryAddress,
    required String location,
    required double lat,
    required double lng,
    required String deliveryPrice,
    required String deliveryTime,
    required File mainPhoto,
    required List<File?> kitchenPhotos,
    required List<WorkingTimeEntity> workingTimes,
    List<int> categoryIds = const [],
  }) {
    final updated = state.formData.copyWith(
      restaurantName: restaurantName,
      restaurantInfo: restaurantInfo,
      countryId: countryId,
      cityId: cityId,
      areaId: areaId,
      deliveryAddress: deliveryAddress,
      location: location,
      lat: lat,
      lng: lng,
      deliveryPrice: deliveryPrice,
      deliveryTime: deliveryTime,
      mainPhoto: mainPhoto,
      kitchenPhotos: kitchenPhotos,
      workingTimes: workingTimes,
      categoryIds: categoryIds,
    );
    emit(RegisterInitial(formData: updated));
  }

  // ---------------------------------------------------------------------------
  // Submit — called only after both steps are complete
  // ---------------------------------------------------------------------------
  Future<void> submitRegistration() async {
    if (state is RegisterLoading) return; // ✋ guard
    if (isClosed) return;

    final data = state.formData;

    // Validate required files
    if (data.idFront == null || data.idBack == null || data.mainPhoto == null) {
      emit(
        RegisterFailure(message: 'Required files are missing.', formData: data),
      );
      return;
    }

    emit(RegisterLoading(formData: data));

    final params = RegisterParams(
      fullName: data.fullName,
      phone: data.phone,
      email: data.email.isEmpty ? null : data.email,
      password: data.password,
      passwordConfirmation: data.password,
      idFront: data.idFront!,
      idBack: data.idBack!,
      restaurantName: data.restaurantName,
      restaurantInfo: data.restaurantInfo,
      countryId: data.countryId ?? 1,
      cityId: data.cityId ?? 1,
      areaId: data.areaId ?? 1,
      deliveryAddress: data.deliveryAddress,
      location: data.location,
      lat: data.lat ?? 0.0,
      lng: data.lng ?? 0.0,
      deliveryPrice: data.deliveryPrice,
      deliveryTime: data.deliveryTime,
      mainPhoto: data.mainPhoto!,
      kitchenPhotos: data.kitchenPhotos,
      workingTimes: data.workingTimes,
      categoryIds: data.categoryIds,
    );

    final result = await _registerUseCase(params);

    if (isClosed) return;

    result.fold(
      (failure) =>
          emit(RegisterFailure(message: failure.message, formData: data)),
      (response) => emit(RegisterSuccess(response: response, formData: data)),
    );
  }

  // ---------------------------------------------------------------------------
  // Reset (for starting over)
  // ---------------------------------------------------------------------------
  void reset() => emit(const RegisterInitial());
}
