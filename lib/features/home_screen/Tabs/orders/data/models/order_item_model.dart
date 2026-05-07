import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/models/item_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    required super.itemId,
    required super.itemName,
    required super.quantity,
    required super.unitPrice,
    required super.discountAmount,
    required super.lineTotal,
    required super.createdAt,
    required super.updatedAt,
    super.item,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      orderId: json['order_id']?.toString() ?? '',
      itemId: json['item_id']?.toString() ?? '',
      itemName: json['item_name']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '0',
      unitPrice: json['unit_price']?.toString() ?? '0.00',
      discountAmount: json['discount_amount']?.toString() ?? '0.00',
      lineTotal: json['line_total']?.toString() ?? '0.00',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      item: json['item'] != null
          ? ItemModel.fromJson(
              Map<String, dynamic>.from(json['item'] as Map),
            )
          : null,
    );
  }
}
