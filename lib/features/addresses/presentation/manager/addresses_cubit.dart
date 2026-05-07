import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/features/addresses/domain/entities/address_entity.dart';
import 'package:home_plate_vendor/features/addresses/domain/repositories/addresses_repository.dart';
import 'package:injectable/injectable.dart';

part 'addresses_state.dart';

@lazySingleton
class AddressesCubit extends Cubit<AddressesState> {
  final AddressesRepository _repository;

  AddressesCubit({required AddressesRepository repository})
    : _repository = repository,
      super(const AddressesState());

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _repository.getAddresses();
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<bool> save({
    int? id,
    required String title,
    required String addressLine1,
    String? addressLine2,
    required String townCity,
    required String regionState,
    required double lat,
    required double lng,
  }) async {
    emit(state.copyWith(isSaving: true, clearError: true));
    final result = id == null
        ? await _repository.createAddress(
            title: title,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            townCity: townCity,
            regionState: regionState,
            lat: lat,
            lng: lng,
          )
        : await _repository.updateAddress(
            id: id,
            title: title,
            addressLine1: addressLine1,
            addressLine2: addressLine2,
            townCity: townCity,
            regionState: regionState,
            lat: lat,
            lng: lng,
          );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (saved) {
        final updated = List<AddressEntity>.from(state.items);
        final idx = updated.indexWhere((e) => e.id == saved.id);
        if (idx >= 0) {
          updated[idx] = saved;
        } else {
          updated.add(saved);
        }
        emit(state.copyWith(isSaving: false, items: updated));
        return true;
      },
    );
  }

  Future<bool> delete(int id) async {
    emit(state.copyWith(isDeleting: true, clearError: true));
    final result = await _repository.deleteAddress(id);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false, errorMessage: failure.message));
        return false;
      },
      (_) {
        emit(
          state.copyWith(
            isDeleting: false,
            items: state.items.where((e) => e.id != id).toList(),
          ),
        );
        return true;
      },
    );
  }
}
