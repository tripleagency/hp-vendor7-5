import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_size_entity.dart';

class ItemSizeModel extends ItemSizeEntity {
  const ItemSizeModel({
    required super.id,
    required super.itemId,
    required super.size,
    required super.price,
  });

  factory ItemSizeModel.fromJson(Map<String, dynamic> json) {
    return ItemSizeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      itemId: json['item_id']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.00',
    );
  }
}
