part of 'items_cubit.dart';

enum ItemsStatus { initial, loading, success, failure }

class ItemsState extends Equatable {
  final ItemsStatus status;
  final List<ItemEntity> items;
  final String? errorMessage;
  final String? successMessage;
  final String? failureMessage;

  const ItemsState({
    this.status = ItemsStatus.initial,
    this.items = const [],
    this.errorMessage,
    this.successMessage,
    this.failureMessage,
  });

  factory ItemsState.initial() => const ItemsState();

  ItemsState copyWith({
    ItemsStatus? status,
    List<ItemEntity>? items,
    String? errorMessage,
    String? successMessage,
    String? failureMessage,
  }) {
    return ItemsState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage,
      failureMessage: failureMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, items, errorMessage, successMessage, failureMessage];
}
