import 'package:equatable/equatable.dart';

class ItemAddonEntity extends Equatable {
  final int id;
  final String itemId;
  final String name;
  final String price;

  const ItemAddonEntity({
    required this.id,
    required this.itemId,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, itemId, name, price];
}
