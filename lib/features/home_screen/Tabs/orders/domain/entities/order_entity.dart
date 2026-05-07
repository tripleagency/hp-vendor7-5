import 'package:equatable/equatable.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/app_user_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/delivery_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_item_entity.dart';

enum OrderStatus {
  pendingVendorPreparation,
  searchingDelivery,
  deliveryAssigned,
  readyForPickup,
  handoverPendingConfirmation,
  pickedUp,
  outForDelivery,
  delivered,
  cancelled,
  unknown;

  static OrderStatus fromString(String status) {
    switch (status) {
      case 'pending_vendor_preparation':
        return OrderStatus.pendingVendorPreparation;
      case 'searching_delivery':
        return OrderStatus.searchingDelivery;
      case 'delivery_assigned':
        return OrderStatus.deliveryAssigned;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'handover_pending_confirmation':
        return OrderStatus.handoverPendingConfirmation;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }

  String toApiString() {
    switch (this) {
      case OrderStatus.pendingVendorPreparation:
        return 'pending_vendor_preparation';
      case OrderStatus.searchingDelivery:
        return 'searching_delivery';
      case OrderStatus.deliveryAssigned:
        return 'delivery_assigned';
      case OrderStatus.readyForPickup:
        return 'ready_for_pickup';
      case OrderStatus.handoverPendingConfirmation:
        return 'handover_pending_confirmation';
      case OrderStatus.pickedUp:
        return 'picked_up';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.unknown:
        return 'unknown';
    }
  }
}

class OrderEntity extends Equatable {
  final int id;
  final String orderNumber;
  final String appUserId;
  final String vendorId;
  final String? deliveryId;
  final String orderCost;
  final String deliveryFee;
  final String totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String? paymentReference;
  final String? deliveryAddress;
  final String? orderedAt;
  final OrderStatus status;
  final String? deliveryPin;
  final String? pinVerifiedAt;
  final String? startedCookingAt;
  final String? deliveryRequestedAt;
  final String? deliveryAcceptedAt;
  final String? readyForPickupAt;
  final String? vendorHandoverConfirmedAt;
  final String? deliveryPickupConfirmedAt;
  final String? pickedUpAt;
  final String? outForDeliveryAt;
  final String? deliveredAt;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final AppUserEntity? appUser;
  final DeliveryEntity? delivery;
  final List<OrderItemEntity> orderItems;

  const OrderEntity({
    required this.id,
    required this.orderNumber,
    required this.appUserId,
    required this.vendorId,
    this.deliveryId,
    required this.orderCost,
    required this.deliveryFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    this.paymentReference,
    this.deliveryAddress,
    this.orderedAt,
    required this.status,
    this.deliveryPin,
    this.pinVerifiedAt,
    this.startedCookingAt,
    this.deliveryRequestedAt,
    this.deliveryAcceptedAt,
    this.readyForPickupAt,
    this.vendorHandoverConfirmedAt,
    this.deliveryPickupConfirmedAt,
    this.pickedUpAt,
    this.outForDeliveryAt,
    this.deliveredAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.appUser,
    this.delivery,
    this.orderItems = const [],
  });

  /// Customer display name
  String get customerName => appUser?.name ?? '';

  /// Customer phone
  String get customerPhone => appUser?.phone ?? '';

  /// Total amount as double
  double get totalAmountDouble => double.tryParse(totalAmount) ?? 0.0;

  /// Order cost as double
  double get orderCostDouble => double.tryParse(orderCost) ?? 0.0;

  /// Delivery fee as double
  double get deliveryFeeDouble => double.tryParse(deliveryFee) ?? 0.0;

  /// Total items count
  int get totalItemsCount => orderItems.fold(
        0,
        (sum, item) => sum + item.quantityInt,
      );

  /// Whether there is a delivery person assigned
  bool get hasDelivery => deliveryId != null;

  /// Delivery person display name
  String get deliveryName => delivery?.displayName ?? '';

  /// Delivery person phone
  String get deliveryPhone => delivery?.phone ?? '';

  /// Whether order is in a terminal state
  bool get isTerminal =>
      status == OrderStatus.delivered || status == OrderStatus.cancelled;

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        appUserId,
        vendorId,
        deliveryId,
        orderCost,
        deliveryFee,
        totalAmount,
        paymentMethod,
        paymentStatus,
        paymentReference,
        deliveryAddress,
        orderedAt,
        status,
        deliveryPin,
        pinVerifiedAt,
        startedCookingAt,
        deliveryRequestedAt,
        deliveryAcceptedAt,
        readyForPickupAt,
        vendorHandoverConfirmedAt,
        deliveryPickupConfirmedAt,
        pickedUpAt,
        outForDeliveryAt,
        deliveredAt,
        notes,
        createdAt,
        updatedAt,
        appUser,
        delivery,
        orderItems,
      ];
}
