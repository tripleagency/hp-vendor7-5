import 'dart:io';

class SizeParam {
  final String size;
  final String price;

  SizeParam({required this.size, required this.price});

  Map<String, dynamic> toJson() => {'size': size, 'price': price};
}

class AddonParam {
  final String name;
  final String price;

  AddonParam({required this.name, required this.price});

  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}

class AddItemParams {
  final String categoryId;
  final String subcategoryId;
  final String name;
  final String description;
  final String price;
  final String? discount;
  final String prepTimeValue;
  final String prepTimeUnit;
  final String stock;
  final String maxOrdersPerDay;
  final List<File> photos;
  final List<SizeParam> sizes;
  final List<AddonParam> addons;

  AddItemParams({
    required this.categoryId,
    required this.subcategoryId,
    required this.name,
    required this.description,
    required this.price,
    this.discount,
    required this.prepTimeValue,
    required this.prepTimeUnit,
    required this.stock,
    required this.maxOrdersPerDay,
    required this.photos,
    this.sizes = const [],
    this.addons = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'name': name,
      'description': description,
      'price': price,
      'discount': discount,
      'prep_time_value': prepTimeValue,
      'prep_time_unit': prepTimeUnit,
      'stock': stock,
      'max_orders_per_day': maxOrdersPerDay,
    };
  }
}
