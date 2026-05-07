import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/add_item/domain/usecases/add_item_params.dart';

abstract class IAddItemRepository {
  Future<Either<Failure, String>> addItem(AddItemParams params);
  Future<Either<Failure, String>> updateItem(int itemId, AddItemParams params);
  Future<Either<Failure, void>> deleteItem(int itemId);
}
