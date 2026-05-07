import 'package:home_plate_vendor/features/auth/data/models/responses/vendor_model.dart';
import 'package:home_plate_vendor/features/general/data/models/category_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/models/item_addon_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/data/models/item_size_model.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';

class ItemModel extends ItemEntity {
  const ItemModel({
    required super.id,
    required super.vendorId,
    required super.categoryId,
    required super.name,
    required super.description,
    required super.price,
    super.discount,
    required super.prepTimeValue,
    required super.prepTimeUnit,
    required super.stock,
    required super.maxOrdersPerDay,
    required super.approvalStatus,
    required super.availabilityStatus,
    required super.photos,
    required super.createdAt,
    required super.updatedAt,
    super.vendor,
    super.category,
    super.sizes,
    super.addons,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    // Parse photos list
    final List<String> photosList = [];
    if (json['photos'] != null && json['photos'] is List) {
      for (final photo in json['photos'] as List) {
        photosList.add(photo.toString());
      }
    }

    // Parse sizes list
    final List<ItemSizeModel> sizesList = [];
    if (json['sizes'] != null && json['sizes'] is List) {
      for (final s in json['sizes'] as List) {
        if (s is Map) {
          sizesList.add(ItemSizeModel.fromJson(Map<String, dynamic>.from(s)));
        }
      }
    }

    // Parse addons list
    final List<ItemAddonModel> addonsList = [];
    if (json['addons'] != null && json['addons'] is List) {
      for (final a in json['addons'] as List) {
        if (a is Map) {
          addonsList.add(ItemAddonModel.fromJson(Map<String, dynamic>.from(a)));
        }
      }
    }

    return ItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      vendorId: json['vendor_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '0.00',
      discount: json['discount']?.toString(),
      prepTimeValue: json['prep_time_value']?.toString() ?? '',
      prepTimeUnit: json['prep_time_unit']?.toString() ?? '',
      stock: json['stock']?.toString() ?? '0',
      maxOrdersPerDay: json['max_orders_per_day']?.toString() ?? '0',
      approvalStatus: json['approval_status']?.toString() ?? '',
      availabilityStatus: json['availability_status']?.toString() ?? '',
      photos: photosList,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      vendor: json['vendor'] != null
          ? VendorModel.fromJson(
              Map<String, dynamic>.from(json['vendor'] as Map),
            )
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,
      sizes: sizesList,
      addons: addonsList,
    );
  }
}
