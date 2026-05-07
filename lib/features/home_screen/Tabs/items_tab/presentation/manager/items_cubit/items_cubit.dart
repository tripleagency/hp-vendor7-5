import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/usecases/get_items_usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/usecases/toggle_item_status_usecase.dart';
import 'package:injectable/injectable.dart';

part 'items_state.dart';

@injectable
class ItemsCubit extends Cubit<ItemsState> {
  final GetItemsUseCase _getItemsUseCase;
  final ToggleItemStatusUseCase _toggleItemStatusUseCase;

  ItemsCubit(
    this._getItemsUseCase,
    this._toggleItemStatusUseCase,
  ) : super(ItemsState.initial());

  Future<void> getItems() async {
    if (state.status == ItemsStatus.loading) return;
    emit(state.copyWith(status: ItemsStatus.loading));

    final result = await _getItemsUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: ItemsStatus.failure,
        errorMessage: failure.message,
      )),
      (items) => emit(state.copyWith(
        status: ItemsStatus.success,
        items: items,
      )),
    );
  }

  Future<void> toggleItemStatus(int itemId, bool publish) async {
    // 1️⃣ احفظ الـ items القديمة عشان نقدر نرجعهم لو الـ API فشل
    final originalItems = List<ItemEntity>.from(state.items);
    final index = originalItems.indexWhere((item) => item.id == itemId);
    if (index == -1) return;

    // 2️⃣ Optimistic update — حدّث الـ Switch فوراً قبل ما نسمع رد الـ Backend
    final original = originalItems[index];
    final optimisticItems = List<ItemEntity>.from(originalItems);
    optimisticItems[index] = ItemEntity(
      id: original.id,
      vendorId: original.vendorId,
      categoryId: original.categoryId,
      name: original.name,
      description: original.description,
      price: original.price,
      discount: original.discount,
      prepTimeValue: original.prepTimeValue,
      prepTimeUnit: original.prepTimeUnit,
      stock: original.stock,
      maxOrdersPerDay: original.maxOrdersPerDay,
      approvalStatus: original.approvalStatus,
      availabilityStatus: publish ? 'published' : 'paused',
      photos: original.photos,
      createdAt: original.createdAt,
      updatedAt: original.updatedAt,
      vendor: original.vendor,
      category: original.category,
      sizes: original.sizes,
      addons: original.addons,
    );
    emit(state.copyWith(items: optimisticItems));

    final result = await _toggleItemStatusUseCase(
      ToggleItemStatusParams(itemId: itemId, publish: publish),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        // 3️⃣ فشل → ارجع للحالة الأصلية + اعرض رسالة الخطأ
        emit(state.copyWith(
          items: originalItems,
          failureMessage: failure.message.isNotEmpty
              ? failure.message
              : 'error_generic_message',
        ));
      },
      (updatedItem) {
        final updatedItems = List<ItemEntity>.from(state.items);
        final idx = updatedItems.indexWhere((item) => item.id == itemId);
        if (idx != -1) {
          updatedItems[idx] = updatedItem;
        }
        final successMsg =
            publish ? 'item_published_success' : 'item_paused_success';
        emit(state.copyWith(
          status: ItemsStatus.success,
          items: updatedItems,
          successMessage: successMsg,
        ));
      },
    );
  }
}
