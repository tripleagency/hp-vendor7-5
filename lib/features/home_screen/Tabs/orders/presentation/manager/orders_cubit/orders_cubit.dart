import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/get_orders_usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/confirm_handover_usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/ready_for_pickup_usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/usecases/start_cooking_usecase.dart';
import 'package:injectable/injectable.dart';

part 'orders_state.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase _getOrdersUseCase;
  final StartCookingUseCase _startCookingUseCase;
  final ReadyForPickupUseCase _readyForPickupUseCase;
  final ConfirmHandoverUseCase _confirmHandoverUseCase;

  OrdersCubit(
    this._getOrdersUseCase,
    this._startCookingUseCase,
    this._readyForPickupUseCase,
    this._confirmHandoverUseCase,
  ) : super(OrdersState.initial());

  Future<void> getOrders() async {
    if (state.status == OrdersStatus.loading) return;
    emit(state.copyWith(status: OrdersStatus.loading));

    final result = await _getOrdersUseCase(const NoParams());
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        status: OrdersStatus.failure,
        errorMessage: failure.message,
      )),
      (orders) => emit(state.copyWith(
        status: OrdersStatus.success,
        orders: orders,
      )),
    );
  }

  /// Start cooking an order
  Future<void> startCooking(int orderId) async {
    _performOrderAction(orderId, _startCookingUseCase);
  }

  /// Mark order as ready for pickup
  Future<void> readyForPickup(int orderId) async {
    _performOrderAction(orderId, _readyForPickupUseCase);
  }

  /// Confirm handover to delivery
  Future<void> confirmHandover(int orderId) async {
    _performOrderAction(orderId, _confirmHandoverUseCase);
  }

  /// Generic order action handler
  Future<void> _performOrderAction(
    int orderId,
    UseCase<OrderEntity, int> useCase,
  ) async {
    emit(state.copyWith(
      actionStatus: OrderActionStatus.loading,
      actionOrderId: orderId,
    ));

    final result = await useCase(orderId);
    if (isClosed) return;

    result.fold(
      (failure) => emit(state.copyWith(
        actionStatus: OrderActionStatus.failure,
        actionErrorMessage: failure.message,
        actionOrderId: orderId,
      )),
      (updatedOrder) {
        // Replace the order in the list with the updated one
        final updatedOrders = state.orders.map((order) {
          return order.id == updatedOrder.id ? updatedOrder : order;
        }).toList();

        emit(state.copyWith(
          actionStatus: OrderActionStatus.success,
          orders: updatedOrders,
          actionOrderId: orderId,
        ));
      },
    );
  }

  /// Reset action status after handling in UI
  void resetActionStatus() {
    emit(state.copyWith(
      actionStatus: OrderActionStatus.idle,
      actionOrderId: null,
      actionErrorMessage: null,
    ));
  }

  /// Get orders filtered by status
  List<OrderEntity> getOrdersByStatus(OrderStatus status) {
    return state.orders.where((order) => order.status == status).toList();
  }

  /// Get new/pending orders
  List<OrderEntity> get pendingOrders =>
      getOrdersByStatus(OrderStatus.pendingVendorPreparation);

  /// Get orders searching for delivery
  List<OrderEntity> get searchingDeliveryOrders =>
      getOrdersByStatus(OrderStatus.searchingDelivery);

  /// Get orders with delivery assigned
  List<OrderEntity> get deliveryAssignedOrders =>
      getOrdersByStatus(OrderStatus.deliveryAssigned);

  /// Get orders ready for pickup
  List<OrderEntity> get readyForPickupOrders =>
      getOrdersByStatus(OrderStatus.readyForPickup);

  /// Get orders out for delivery
  List<OrderEntity> get outForDeliveryOrders =>
      getOrdersByStatus(OrderStatus.outForDelivery);

  /// Get delivered orders
  List<OrderEntity> get deliveredOrders =>
      getOrdersByStatus(OrderStatus.delivered);

  /// Get cancelled orders
  List<OrderEntity> get cancelledOrders =>
      getOrdersByStatus(OrderStatus.cancelled);

  /// Get active orders (non-terminal)
  List<OrderEntity> get activeOrders =>
      state.orders.where((order) => !order.isTerminal).toList();
}
