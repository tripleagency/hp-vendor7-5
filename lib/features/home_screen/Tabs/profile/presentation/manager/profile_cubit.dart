import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/get_vendor_profile_usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_params.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/profile/domain/usecases/update_profile_usecase.dart';
import 'package:injectable/injectable.dart';

part 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  final GetVendorProfileUseCase _getVendorProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit({
    required GetVendorProfileUseCase getVendorProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
  }) : _getVendorProfileUseCase = getVendorProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       super(ProfileState.initial());

  Future<void> getVendorProfile(int vendorId) async {
    if (state.status == ProfileStatus.loading) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _getVendorProfileUseCase(vendorId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (vendor) =>
          emit(state.copyWith(status: ProfileStatus.success, vendor: vendor)),
    );
  }

  void updateFromVendor(VendorEntity vendor) {
    emit(state.copyWith(status: ProfileStatus.success, vendor: vendor));
  }

  void updateProfileImage(File? image) {
    emit(state.copyWith(localProfileImage: image));
  }

  Future<void> updateVendorProfile(
    int vendorId,
    UpdateProfileParams params,
  ) async {
    if (state.status == ProfileStatus.loading) return;

    emit(state.copyWith(status: ProfileStatus.loading));

    final result = await _updateProfileUseCase(vendorId, params);

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (vendor) =>
          emit(state.copyWith(status: ProfileStatus.success, vendor: vendor)),
    );
  }

  void clearProfile() {
    emit(ProfileState.initial());
  }

  void emitFailure(String message) {
    emit(state.copyWith(status: ProfileStatus.failure, errorMessage: message));
  }
}
