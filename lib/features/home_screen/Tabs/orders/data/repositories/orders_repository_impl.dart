import 'package:dartz/dartz.dart';
import 'package:home_plate_vendor/core/errors/exceptions.dart';
import 'package:home_plate_vendor/core/errors/failure.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/datasources/orders_remote_data_source.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/entities/order_entity.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    return _handleRepoCall(() => _remoteDataSource.getOrders());
  }

  @override
  Future<Either<Failure, OrderEntity>> startCooking(int orderId) async {
    return _handleRepoCall(() => _remoteDataSource.startCooking(orderId));
  }

  @override
  Future<Either<Failure, OrderEntity>> readyForPickup(int orderId) async {
    return _handleRepoCall(() => _remoteDataSource.readyForPickup(orderId));
  }

  @override
  Future<Either<Failure, OrderEntity>> confirmHandover(int orderId) async {
    return _handleRepoCall(() => _remoteDataSource.confirmHandover(orderId));
  }

  Future<Either<Failure, T>> _handleRepoCall<T>(
    Future<T> Function() call,
  ) async {
    try {
      final result = await call();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, errors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on ParseException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
