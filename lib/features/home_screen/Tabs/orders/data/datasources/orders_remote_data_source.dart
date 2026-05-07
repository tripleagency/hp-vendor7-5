import 'package:home_plate_vendor/core/api/dio_consumer.dart';
import 'package:home_plate_vendor/core/api/server_strings.dart';
import 'package:home_plate_vendor/features/home_screen/Tabs/orders/data/models/order_model.dart';
import 'package:injectable/injectable.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> startCooking(int orderId);
  Future<OrderModel> readyForPickup(int orderId);
  Future<OrderModel> confirmHandover(int orderId);
}

@LazySingleton(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final DioConsumer _apiConsumer;

  OrdersRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await _apiConsumer.get(ServerStrings.getVendorOrders);
    final List<dynamic> data = response['data'] ?? [];
    return data
        .map(
          (order) =>
              OrderModel.fromJson(Map<String, dynamic>.from(order as Map)),
        )
        .toList();
  }

  @override
  Future<OrderModel> startCooking(int orderId) async {
    final response = await _apiConsumer.post(
      ServerStrings.startCooking(orderId),
    );
    final data = response['data'];
    return OrderModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  @override
  Future<OrderModel> readyForPickup(int orderId) async {
    final response = await _apiConsumer.post(
      ServerStrings.readyForPickup(orderId),
    );
    final data = response['data'];
    return OrderModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  @override
  Future<OrderModel> confirmHandover(int orderId) async {
    final response = await _apiConsumer.post(
      ServerStrings.confirmHandover(orderId),
    );
    final data = response['data'];
    return OrderModel.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
