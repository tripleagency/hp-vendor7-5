import 'package:equatable/equatable.dart';

class ItemSizeEntity extends Equatable {
  final int id;
  final String itemId;
  final String size;
  final String price;

  const ItemSizeEntity({
    required this.id,
    required this.itemId,
    required this.size,
    required this.price,
  });

  @override
  List<Object?> get props => [id, itemId, size, price];
}
