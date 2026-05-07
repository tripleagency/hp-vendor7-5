import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> startCooking(int orderId);
  Future<Either<Failure, OrderEntity>> readyForPickup(int orderId);
  Future<Either<Failure, OrderEntity>> confirmHandover(int orderId);
}
