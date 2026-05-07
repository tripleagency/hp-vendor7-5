import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/models/app_user_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/models/delivery_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/models/order_item_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.appUserId,
    required super.vendorId,
    super.deliveryId,
    required super.orderCost,
    required super.deliveryFee,
    required super.totalAmount,
    required super.paymentMethod,
    required super.paymentStatus,
    super.paymentReference,
    super.deliveryAddress,
    super.orderedAt,
    required super.status,
    super.deliveryPin,
    super.pinVerifiedAt,
    super.startedCookingAt,
    super.deliveryRequestedAt,
    super.deliveryAcceptedAt,
    super.readyForPickupAt,
    super.vendorHandoverConfirmedAt,
    super.deliveryPickupConfirmedAt,
    super.pickedUpAt,
    super.outForDeliveryAt,
    super.deliveredAt,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    super.appUser,
    super.delivery,
    super.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final List<OrderItemModel> orderItemsList = [];
    if (json['order_items'] != null && json['order_items'] is List) {
      for (final item in json['order_items'] as List) {
        orderItemsList.add(
          OrderItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
        );
      }
    }

    return OrderModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderNumber: json['order_number']?.toString() ?? '',
      appUserId: json['app_user_id']?.toString() ?? '',
      vendorId: json['vendor_id']?.toString() ?? '',
      deliveryId: json['delivery_id']?.toString(),
      orderCost: json['order_cost']?.toString() ?? '0.00',
      deliveryFee: json['delivery_fee']?.toString() ?? '0.00',
      totalAmount: json['total_amount']?.toString() ?? '0.00',
      paymentMethod: json['payment_method']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      paymentReference: json['payment_reference']?.toString(),
      deliveryAddress: json['delivery_address']?.toString(),
      orderedAt: json['ordered_at']?.toString(),
      status: OrderStatus.fromString(json['status']?.toString() ?? ''),
      deliveryPin: json['delivery_pin']?.toString(),
      pinVerifiedAt: json['pin_verified_at']?.toString(),
      startedCookingAt: json['started_cooking_at']?.toString(),
      deliveryRequestedAt: json['delivery_requested_at']?.toString(),
      deliveryAcceptedAt: json['delivery_accepted_at']?.toString(),
      readyForPickupAt: json['ready_for_pickup_at']?.toString(),
      vendorHandoverConfirmedAt:
          json['vendor_handover_confirmed_at']?.toString(),
      deliveryPickupConfirmedAt:
          json['delivery_pickup_confirmed_at']?.toString(),
      pickedUpAt: json['picked_up_at']?.toString(),
      outForDeliveryAt: json['out_for_delivery_at']?.toString(),
      deliveredAt: json['delivered_at']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      appUser: json['app_user'] != null
          ? AppUserModel.fromJson(
              Map<String, dynamic>.from(json['app_user'] as Map),
            )
          : null,
      delivery: json['delivery'] != null
          ? DeliveryModel.fromJson(
              Map<String, dynamic>.from(json['delivery'] as Map),
            )
          : null,
      orderItems: orderItemsList,
    );
  }
}
