import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/core/usecases/usecase.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ConfirmHandoverUseCase implements UseCase<OrderEntity, int> {
  final OrdersRepository _repository;

  ConfirmHandoverUseCase(this._repository);

  @override
  Future<Either<Failure, OrderEntity>> call(int orderId) async {
    return await _repository.confirmHandover(orderId);
  }
}
