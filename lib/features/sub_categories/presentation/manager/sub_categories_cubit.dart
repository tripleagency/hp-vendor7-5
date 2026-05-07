import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/entities/sub_category_entity.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/usecases/get_sub_categories_usecase.dart';
import 'package:home_plate_vendor/features/sub_categories/domain/usecases/save_sub_category_usecase.dart';
import 'package:injectable/injectable.dart';

part 'sub_categories_state.dart';

@lazySingleton
class SubCategoriesCubit extends Cubit<SubCategoriesState> {
  final GetSubCategoriesUseCase _getUseCase;
  final SaveSubCategoryUseCase _saveUseCase;
  final DeleteSubCategoryUseCase _deleteUseCase;

  SubCategoriesCubit({
    required GetSubCategoriesUseCase getUseCase,
    required SaveSubCategoryUseCase saveUseCase,
    required DeleteSubCategoryUseCase deleteUseCase,
  }) : _getUseCase = getUseCase,
       _saveUseCase = saveUseCase,
       _deleteUseCase = deleteUseCase,
       super(const SubCategoriesState());

  Future<void> fetch() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    final result = await _getUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (items) => emit(state.copyWith(isLoading: false, items: items)),
    );
  }

  Future<bool> save({
    int? id,
    required String nameEn,
    required String nameAr,
    required int categoryId,
  }) async {
    emit(state.copyWith(isSaving: true, clearError: true));
    final result = await _saveUseCase(
      SaveSubCategoryParams(
        id: id,
        nameEn: nameEn,
        nameAr: nameAr,
        categoryId: categoryId,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(
          state.copyWith(isSaving: false, errorMessage: failure.message),
        );
        return false;
      },
      (saved) {
        final updated = List<SubCategoryEntity>.from(state.items);
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
    final result = await _deleteUseCase(id);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(
          state.copyWith(isDeleting: false, errorMessage: failure.message),
        );
        return false;
      },
      (_) {
        final updated = state.items.where((e) => e.id != id).toList();
        emit(state.copyWith(isDeleting: false, items: updated));
        return true;
      },
    );
  }
}
