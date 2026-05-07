import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/items_tab/domain/entities/item_entity.dart';

abstract class ItemsRepository {
  Future<Either<Failure, List<ItemEntity>>> getItems();
  Future<Either<Failure, ItemEntity>> toggleItemStatus(int itemId, bool publish);
}
