import 'package:equatable/equatable.dart';
import 'package:home_plate_vendor/features/auth/domain/entities/vendor_entity.dart';
import 'package:home_plate_vendor/features/general/domain/entities/category_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_size_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_addon_entity.dart';

class ItemEntity extends Equatable {
  final int id;
  final String vendorId;
  final String categoryId;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String price;
  final String? discount;
  final String prepTimeValue;
  final String prepTimeUnit;
  final String stock;
  final String maxOrdersPerDay;
  final String approvalStatus;
  final String availabilityStatus;
  final List<String> photos;
  final String createdAt;
  final String updatedAt;
  final VendorEntity? vendor;
  final CategoryEntity? category;
  final List<ItemSizeEntity> sizes;
  final List<ItemAddonEntity> addons;

  const ItemEntity({
    required this.id,
    required this.vendorId,
    required this.categoryId,
    required this.name,
    this.nameAr = '',
    required this.description,
    this.descriptionAr = '',
    required this.price,
    this.discount,
    required this.prepTimeValue,
    required this.prepTimeUnit,
    required this.stock,
    required this.maxOrdersPerDay,
    required this.approvalStatus,
    required this.availabilityStatus,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
    this.vendor,
    this.category,
    this.sizes = const [],
    this.addons = const [],
  });

  /// Whether the item is currently published
  bool get isPublished => availabilityStatus == 'published';

  /// First photo URL (for thumbnail display)
  String? get thumbnailUrl => photos.isNotEmpty ? photos.first : null;

  /// Effective price after discount
  double get effectivePrice {
    final basePrice = double.tryParse(price) ?? 0.0;
    final discountAmount = double.tryParse(discount ?? '') ?? 0.0;
    return basePrice - discountAmount;
  }

  @override
  List<Object?> get props => [
        id,
        vendorId,
        categoryId,
        name,
        nameAr,
        description,
        descriptionAr,
        price,
        discount,
        prepTimeValue,
        prepTimeUnit,
        stock,
        maxOrdersPerDay,
        approvalStatus,
        availabilityStatus,
        photos,
        createdAt,
        updatedAt,
        sizes,
        addons,
      ];
}
