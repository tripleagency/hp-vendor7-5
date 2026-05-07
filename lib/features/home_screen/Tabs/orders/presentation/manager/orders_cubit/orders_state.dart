part of 'orders_cubit.dart';

enum OrdersStatus { initial, loading, success, failure }

enum OrderActionStatus { idle, loading, success, failure }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;
  final OrderActionStatus actionStatus;
  final int? actionOrderId;
  final String? actionErrorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.errorMessage,
    this.actionStatus = OrderActionStatus.idle,
    this.actionOrderId,
    this.actionErrorMessage,
  });

  factory OrdersState.initial() => const OrdersState();

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
    OrderActionStatus? actionStatus,
    int? actionOrderId,
    String? actionErrorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage,
      actionStatus: actionStatus ?? this.actionStatus,
      actionOrderId: actionOrderId ?? this.actionOrderId,
      actionErrorMessage: actionErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        errorMessage,
        actionStatus,
        actionOrderId,
        actionErrorMessage,
      ];
}
