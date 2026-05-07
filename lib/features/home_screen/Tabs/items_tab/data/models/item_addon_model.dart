import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_addon_entity.dart';

class ItemAddonModel extends ItemAddonEntity {
  const ItemAddonModel({
    required super.id,
    required super.itemId,
    required super.name,
    required super.price,
  });

  factory ItemAddonModel.fromJson(Map<String, dynamic> json) {
    return ItemAddonModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      itemId: json['item_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.00',
    );
  }
}
