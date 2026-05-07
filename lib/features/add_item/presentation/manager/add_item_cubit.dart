import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/add_item/domain/repositories/i_add_item_repository.dart';
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_params.dart';
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_usecase.dart';
import 'package:injectable/injectable.dart';

part 'add_item_state.dart';

@injectable
class AddItemCubit extends Cubit<AddItemState> {
  final AddItemUseCase _addItemUseCase;
  final IAddItemRepository _repository;

  AddItemCubit(this._addItemUseCase, this._repository)
    : super(AddItemInitial());

  Future<void> addItem(AddItemParams params) async {
    emit(AddItemLoading());

    final result = await _addItemUseCase(params);

    result.fold((failure) {
      if (failure is ValidationFailure) {
        emit(AddItemError(failure.message, errors: failure.errors));
      } else {
        emit(AddItemError(failure.message));
      }
    }, (message) => emit(AddItemSuccess(message)));
  }

  Future<void> updateItem(int itemId, AddItemParams params) async {
    emit(AddItemLoading());

    final result = await _repository.updateItem(itemId, params);

    result.fold((failure) {
      if (failure is ValidationFailure) {
        emit(AddItemError(failure.message, errors: failure.errors));
      } else {
        emit(AddItemError(failure.message));
      }
    }, (message) => emit(AddItemSuccess(message)));
  }
}
