import 'package:equatable/equatable.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';

class OrderItemEntity extends Equatable {
  final int id;
  final String orderId;
  final String itemId;
  final String itemName;
  final String quantity;
  final String unitPrice;
  final String discountAmount;
  final String lineTotal;
  final String createdAt;
  final String updatedAt;
  final ItemEntity? item;

  const OrderItemEntity({
    required this.id,
    required this.orderId,
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    required this.discountAmount,
    required this.lineTotal,
    required this.createdAt,
    required this.updatedAt,
    this.item,
  });

  int get quantityInt => int.tryParse(quantity) ?? 0;

  double get unitPriceDouble => double.tryParse(unitPrice) ?? 0.0;

  double get lineTotalDouble => double.tryParse(lineTotal) ?? 0.0;

  String? get itemThumbnailUrl {
    if (item != null && item!.photos.isNotEmpty) {
      return item!.photos.first;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        itemId,
        itemName,
        quantity,
        unitPrice,
        discountAmount,
        lineTotal,
        createdAt,
        updatedAt,
        item,
      ];
}
